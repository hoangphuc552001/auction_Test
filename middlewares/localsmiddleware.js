import categorymodel from '../models/categorymodel.js';
import multer from "multer";
import productmodel from "../models/productmodel.js";
export default function (app) {
    app.use(async function (req, res, next) {
        res.locals.session = req.session;
        next();
    })

    app.use(async function (req, res, next) {
        const category = await categorymodel.findAllWithDetails();
        res.locals.categories = category;
        var proRenew = await productmodel.getProRenew()
        for (let i = 0; i < proRenew.length; i++) {
            if (proRenew[i].end.getTime() <= new Date().getTime() && proRenew[i].renew===+1) {
                await productmodel.updateProRenew(proRenew[i].id,new Date(proRenew[i].end.getTime() + 15*60000))
                await productmodel.updateRenewCondition(proRenew[i].id)
            }
        }
        await productmodel.test();
        next();
    })
    app.use(async function (req, res, next) {
        if (typeof (req.session.authenticated) === 'undefined') {
            req.session.authenticated = false;
        }
        if (typeof (req.session.admin) === 'undefined') {
            req.session.admin = false;
        }
        if (typeof (req.session.login) === 'undefined') {
            req.session.login = false;
        }
        res.locals.admin = req.session.admin
        res.locals.authenticated = req.session.authenticated;
        res.locals.user = req.session.user;
        if (res.locals.user) {
            var user_ = res.locals.user
            user_ = user_.name
            user_ = user_.split(" ")
            user_ = user_[0]
            res.locals.userName = user_
        }
        var getCategories=await productmodel.getCategories()
        for (let i=0;i<getCategories.length;i++){
            getCategories[i].stt=i+1
        }
        res.locals.categories_=getCategories
        next();
    })
};

