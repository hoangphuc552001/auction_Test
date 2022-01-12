import express from 'express';
import morgan from 'morgan';
import activate_view_middleware from './middlewares/view.mdw.js';
import activate_route_middleware from './middlewares/routes.mdw.js'
import activate_locals_middleware from './middlewares/localsmiddleware.js';
import activate_session_middleware from './middlewares/sessions.mdw.js';
import mail_middleware from './middlewares/mail.mdw.js'
import asyncErrors from 'express-async-errors'
import cron from 'node-cron';
import crypt from "./utils/crypt.js";
import mailgu from "mailgun-js";
import productmodel from "./models/productmodel.js";
//expressjs declare
const app = express()
const port = process.env.PORT || 3000
app.use('/public',express.static('public'))
//morgan
app.use(morgan('dev'));
//middleware declare for post method
app.use(express.urlencoded({extended:true}));
//view


app.use('/public',express.static('public'))
app.get("/", async function (req, res) {
    const highestprice = await productmodel.findTop5ProHighest();
    const mostbids = await productmodel.findTop5ProMostBids();
    const instance = await productmodel.findTop5ProInstance();
    if (req.session.authenticated !==false){
        const listProductUser=await productmodel.getProductwithUser(req.session.user.id);
        for (let i=0;i<highestprice.length;i++){
            highestprice[i].authenticated=req.session.authenticated;
            mostbids[i].authenticated=req.session.authenticated;
            instance[i].authenticated=req.session.authenticated;
            if (highestprice[i].holder===+req.session.user.id) highestprice[i].holderBid=true
            if (mostbids[i].holder===+req.session.user.id) mostbids[i].holderBid=true
            if (instance[i].holder===+req.session.user.id) instance[i].holderBid=true
            for (let j=0;j<listProductUser.length;j++){
                if (listProductUser[j].product===highestprice[i].id){
                    highestprice[i].checkwl=true;
                    mostbids[i].checkwl=true;
                    instance[i].checkwl=true;
                }
            }
        }
    }
    res.render("index", {
        highestprice,
        mostbids,
        instance,
        activeHome:true,
        empty:
            mostbids.length === 0 ||
            highestprice.length === 0 ||
            instance.length === 0,
    });
})
// activate_session_middleware(app);
// activate_locals_middleware(app)
//
// activate_view_middleware(app);
// //routes
// activate_route_middleware(app);
// //
// mail_middleware(app);
app.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`)
})