

//const imagemodel = require('../models/imagemodel');
//import config  from'../config/default.json';

import express from "express";

import productmodel from "../models/productmodel.js";
import imagemodel from "../models/imagemodel.js"
import admin from "../middlewares/admin.mdw.js"
const router = express.Router();
import categorymodel from "../models/categorymodel.js";
// router.get('/', async function (req, res) {
//     await productmodel.refresh();
//     var category = await categorymodel.all();
//     var end = await productmodel.end();
//     var price = await productmodel.price();
//     var bid = await productmodel.bid();
    
//     res.render('./admin', {
//         end: end,
//         price: price,
//         bid: bid,
//         category: category
//     });
// });

router.get('/', admin,async function (req, res) {
  
    let page = +req.query.page || 1;
    if (page < 0)
        page = 1;
    const offset = (page - 1) * 24;
    const total = await productmodel.total();
    const rows = await productmodel.page(offset);

    const nPages = Math.ceil(total / 24);
    const page_items = [];
    for (let i = 1; i <= nPages; i++) {
      const item = {
        value: i,
        isActive: i === page
      }
      page_items.push(item);
    }
    res.render('./product', {
      products: rows,
      empty: rows.length === 0,
      page_items,
      can_go_prev: page > 1,
      can_go_next: page < nPages,
      prev_value: page - 1,
      next_value: page + 1,
    })
    // req.session.products = rows;
    // res.redirect('/admin/product');
  })


// delete product by id
router.post('/del/:ProdId',admin,async function (req, res) {
    const rss = await imagemodel.delete(req.params.ProdId);
    const rs = await productmodel.delete(req.params.ProdId);
    res.redirect('/admin/product');
});

export default router;