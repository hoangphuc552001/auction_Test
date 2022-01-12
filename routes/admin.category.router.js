


import express from "express";
const router = express.Router();
import productmodel from "../models/productmodel.js";
import categorymodel from "../models/categorymodel.js";


import admin from "../middlewares/admin.mdw.js"

router.get('/', admin ,async function (req, res) {
    //await productmodel.refresh();
    const category = await categorymodel.findAllWithDetails();
    res.render('./category', {
        category: category
    });
});

router.get('/category-add',admin,async function (req, res) {
    const category = await categorymodel.all();

    res.render('./category-add', {
        category: category
    }
    );
});

//submit new category to database
    router.post('/category-add',admin,async function (req, res) {
    //if high level category
    if(req.body.txtcategoryParent !== '-1'){
        const entity = {
            name : req.body.txtCatName,
            parent : req.body.txtcategoryParent,
        }
        console.log(entity);
        const rs = await categorymodel.insert(entity);
    }
    //if low level category
    else{
        const entity = {
            name : req.body.txtCatName
        }
        console.log(entity);
        const rs = await categorymodel.insert(entity);
    }
    
    //this equals router.get('/category-add',
    var category = await categorymodel.all();
    
    res.render('./category-add', {
        category: category
    }
    );
});

// get category info by id
router.get('/category-view/:CatId',admin,async function (req, res) {
    //queried entity
    const category = await categorymodel.getById(req.params.CatId);
    if(category === null) 
        throw new Error('Invalid parameter');
    if(category.parent === null)
        category.parent = 'NULL';
    
    //quantity of product which has selected category
    const quantity = await productmodel.countByCat(req.params.CatId);

    res.render('./category-view', {
        category,
        quantity
    }
    );
});

// get info and edit category by id
router.get('/category-edit/:CatId',admin,async function (req, res) {
    //queried entity
    const category = await categorymodel.getById(req.params.CatId);
    if(category === null) 
        throw new Error('Invalid parameter');
    if(category.parent === null)
        category.parent = 'NULL';   
    //quantity of product which has selected category
    const quantity = await productmodel.countByCat(req.params.CatId);

    //get parent of selected category
    var parent = await categorymodel.getById(category.parent);
    if (parent === null) {
        parent = {
            id: null,
            name: "NULL",
        }
    }
    //
    // await productmodel.refresh();
    const categories = await categorymodel.all();
    res.render('./category-edit', {
        categories,
        category,
        quantity,
        parent
    }
    );
});

//post
router.post('/category-edit/:catid',admin, async function(req, res){
    const entity = {
        id: req.body.txtCatId,
        name: req.body.txtCatName,
        parent: req.body.txtCatPar
    }
    if(entity.parent === '' || entity.parent===entity.id){
        entity.parent = null;
    }
    const rs = await categorymodel.update(entity);


    res.redirect('/admin/category');
})


// delete category by id
router.post('/del/:CatId',admin,async function (req, res) {
    const isParent = await categorymodel.isParent(req.params.CatId);
    const quantity = await productmodel.countByCat(req.params.CatId);
  //  console.log(req.params.CatId);
  //  console.log(isParent);
 //   console.log(quantity);
    var message = "Can not delete category contains product";
    if(quantity === 0 && isParent !== true){
        const rs = await categorymodel.delete(req.params.CatId);
        message = "Category deleted";
    }
   
    res.redirect('/admin/category');
});

export default router;