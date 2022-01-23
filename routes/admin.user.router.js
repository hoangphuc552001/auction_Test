
import express, {request} from "express";
import productmodel from "../models/productmodel.js";
import categorymodel from "../models/categorymodel.js";
import usermodel from "../models/usermodel.js";
import admin from "../middlewares/admin.mdw.js"
import bcrypt from "bcryptjs";
const router = express.Router();
import mailgu from "mailgun-js";
import crypt from "../utils/crypt.js";
const API ='51dab083705af99068f43fc917bd8f8f-ef80054a-3f8dbcb0';
const DOMAIN='sandboxf969494c656d42e59f3631dd84278703.mailgun.org';


const mailgun = mailgu({apiKey: API, domain: DOMAIN});
router.get('/',admin, async function (req, res) {

    const bidder = await usermodel.findBidder();
    const seller = await usermodel.findSeller();
    const request = await usermodel.findRequest();
    //console.log(user);

    res.render('./user', {
        bidder: bidder,
        seller:seller,
        request:request
    });

});

router.get('/changepassword/:id',admin,function (req,res){

    return res.render('edit-password');
});
router.post('/changepassword/:id',admin,async function (req,res){
    const id = req.params.id;
    const password = req.body.txtPassword;
    const salt = bcrypt.genSaltSync(10);
    const hash = bcrypt.hashSync(password, salt);
    const result = await usermodel.AdminPassword(id,hash);
    var current_user = await usermodel.AdminGetMail(id);
    current_user = current_user[0];
    console.log(current_user);
    const data = {
        from: 'GPA Team <HCMUS@fit.com>',
        to: current_user.email,
        subject: 'Online Auction',
        text: `Hi ${current_user.email}\nYour password has been changed
      \nHere is your new password: ${password}\nThank you for joining us!\nGPA Team`
    };
    mailgun.messages().send(data);

    return res.redirect('/admin/user');
})
router.get('/user-view/:UserId',admin,async function (req, res){
  //  await usermodel.refresh();
    const user = await usermodel.id(req.params.UserId);
    res.render('./user-view', {
        user: user[0],
    });
});

router.post('/down-seller/:UserId',admin,async function (req, res) {
    const entity = {
        id: req.params.UserId,
        request: "0",
        privilege: "bidder"
    }
    const rs = await usermodel.changeType(entity);
    res.redirect('/admin/user');
});

router.post('/del-user/:UserId',admin,async function (req, res) {
    const product = await productmodel.countByUser(req.params.UserId);
    if(product === 0){
        console.log("can delete this user");
        const rs = await usermodel.delete(req.params.UserId);
    }
    else{
        console.log("canot delete this user");
    }
    res.redirect('/admin/user');
});

router.post('/up-bidder/:UserId',admin,async function (req, res) {
    const entity = {
        id: req.params.UserId,
        request: "0",
        privilege: "seller"
    }
    // console.log(req.params.UserId);
    const rs = await usermodel.changeType(entity);
    res.redirect('/admin/user');
});
//add user
// router.get('/user-add',async function (req, res) {
//     res.render('./user-add');
// });


// upgrade bidder by id
//router.post('/up-bidder/:UserId',async function (req, res) {
//    const entity = {
//        id: req.params.UserId,
//        request: "none",
//        privilege: "seller"
//    }
//    // console.log(req.params.UserId);
//    const rs = await usermodel.changeType(entity);
//    res.redirect('/admin/user');
//});
//
//// downgrade seller by id
//router.post('/down-seller/:UserId',async function (req, res) {
//    const entity = {
//        id: req.params.UserId,
//        request: "none",
//        privilege: "bidder"
//    }
//    const rs = await usermodel.changeType(entity);
//    res.redirect('/admin/user');
//});
//
////delete user by id
//router.post('/del-user/:UserId',async function (req, res) {
//    const product = await productmodel.countByUser(req.params.UserId);
//    if(product === 0){
//        console.log("can delete this user");
//        const rs = await usermodel.delete(req.params.UserId);
//    }
//    else{
//        console.log("canot delete this user");
//    }
//    res.redirect('/admin/user');
//});

export default router;