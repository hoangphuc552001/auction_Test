import productmodel from "../../models/productmodel.js";
import express from "express";
import usermodel from "../../models/usermodel.js";
const app = express.Router();
app.get("/byCat/:id", async function (req, res) {
    const catID=req.params.id || 0;
    for (const c of res.locals.categories){
        if (c.id === +catID){
            c.isActive=true;
            break;
        }
    }
    //paging
    var page=+req.query.page||1;
    if (page<0) page=1;
    const offset=(page-1)*9;
    let [list,total] =await Promise.all([
        productmodel.pageByCat(catID,9,offset),
        productmodel.totalOfCat(catID)
    ]);
    const oneDay = 24 * 60 * 60 * 1000; // hours*minutes*seconds*milliseconds
    for (let i=0;i<list.length;i++){
        const diffDaysEreader= Math.round(Math.abs((list[i].end - list[i].start) / oneDay));
        list[i].day=diffDaysEreader;
        var diffMsEreader=(new Date() - list[i].start)
        var checkMinuteEreader=
            Math.round(((diffMsEreader  % 86400000) % 3600000) / 60000)
            +Math.floor(diffMsEreader / 86400000)*24*60+Math.floor((diffMsEreader % 86400000) / 3600000)*60; // minutes
        list[i].minute=checkMinuteEreader<=15?1:0
    }
    total=total[0]['count(*)']
    const nPages=Math.ceil(total/9);
    const page_items=[];
    for (let i=1;i<=nPages;i++){
        const item={
            value:i,
            isActive:i===page
        }
        page_items.push(item)
    }
    if (req.session.authenticated!==false){
        const listProductUser=await productmodel.getProductwithUser(req.session.user.id);
        for (let i=0;i<list.length;i++){
            list[i].authenticated=res.locals.authenticated;
            for (let j=0;j<listProductUser.length;j++){
                if (listProductUser[j].product===list[i].id){
                    list[i].checkwl=true;
                }
            }
            if (list[i].holder===+req.session.user.id) list[i].holderBid=true
        }
    }
    res.render("productType/product", {
        products: list,
        empty: list.length === 0,
        layout:'layoutwithCat.hbs',
        page_items,
        prev_value:page-1,
        next_value:page+1,
        can_go_prev:page>1,
        can_go_next:page<nPages,

    });
});
app.get("/searchPrice", async function (req, res) {
    var page=+req.query.page||1;
    if (page<0) page=1;
    const offset=(page-1)*9;
    let [list,total] =await Promise.all([
        productmodel.orderedByPrice(9,offset),
        productmodel.totalorderByPrice()
    ]);
    const oneDay = 24 * 60 * 60 * 1000; // hours*minutes*seconds*milliseconds
    for (let i=0;i<list.length;i++){
        const diffDaysEreader= Math.round(Math.abs((list[i].end - list[i].start) / oneDay));
        list[i].day=diffDaysEreader;
        var diffMsEreader=(new Date() - list[i].start)
        var checkMinuteEreader=
            Math.round(((diffMsEreader  % 86400000) % 3600000) / 60000)
            +Math.floor(diffMsEreader / 86400000)*24*60+Math.floor((diffMsEreader % 86400000) / 3600000)*60; // minutes
        list[i].minute=checkMinuteEreader<=15?1:0
    }
    total=total[0]['count(*)']
    const nPages=Math.ceil(total/9);
    const page_items=[];

    for (let i=1;i<=nPages;i++){
        const item={
            value:i,
            isActive:i===page
        }
        page_items.push(item)
    }
    if (req.session.authenticated!==false){
        const listProductUser=await productmodel.getProductwithUser(req.session.user.id);
        for (let i=0;i<list.length;i++){
            list[i].authenticated=res.locals.authenticated;
            for (let j=0;j<listProductUser.length;j++){
                if (listProductUser[j].product===list[i].id){
                    list[i].checkwl=true;
                }
            }
        }
    }
    res.render("productType/product", {
        products:list,
        empty: list.length === 0,
        layout:'layoutwithCat.hbs',
        page_items,
        prev_value:page-1,
        next_value:page+1,
        can_go_prev:page>1,
        can_go_next:page<nPages,
        activePrice:true
    })
})
app.get("/searchTime", async function (req, res) {
    var page=+req.query.page||1;
    if (page<0) page=1;
    const offset=(page-1)*9;
    let [list,total] =await Promise.all([
        productmodel.orderedByTime(9,offset),
        productmodel.totalorderByTime()
    ]);
    const oneDay = 24 * 60 * 60 * 1000; // hours*minutes*seconds*milliseconds
    for (let i=0;i<list.length;i++){
        const diffDaysEreader= Math.round(Math.abs((list[i].end - list[i].start) / oneDay));
        list[i].day=diffDaysEreader;
        var diffMsEreader=(new Date() - list[i].start)
        var checkMinuteEreader=
            Math.round(((diffMsEreader  % 86400000) % 3600000) / 60000)
            +Math.floor(diffMsEreader / 86400000)*24*60+Math.floor((diffMsEreader % 86400000) / 3600000)*60; // minutes
        list[i].minute=checkMinuteEreader<=15?1:0
    }
    total=total[0]['count(*)']
    const nPages=Math.ceil(total/9);
    const page_items=[];

    for (let i=1;i<=nPages;i++){
        const item={
            value:i,
            isActive:i===page
        }
        page_items.push(item)
    }

    if (req.session.authenticated!==false){

        const listProductUser=await productmodel.getProductwithUser(req.session.user.id);
        for (let i=0;i<list.length;i++){
            list[i].authenticated=res.locals.authenticated;
            for (let j=0;j<listProductUser.length;j++){
                if (listProductUser[j].product===list[i].id){
                    list[i].checkwl=true;
                }
            }
        }
    }
    res.render("productType/product", {
        products:list,
        empty: list.length === 0,
        layout:'layoutwithCat.hbs',
        page_items,
        prev_value:page-1,
        next_value:page+1,
        can_go_prev:page>1,
        can_go_next:page<nPages,
        activeTime:true,

    })
})
app.get("/search",async function (req, res) {
    var searchpro=req.query.name;
    var page=+req.query.page||1;
    if (page<0) page=1;
    const offset=(page-1)*9;
    let [list,total] =await Promise.all([
        productmodel.searchFullText(searchpro,9,offset),
        productmodel.totalSearchFullText(searchpro)
    ]);
    const oneDay = 24 * 60 * 60 * 1000; // hours*minutes*seconds*milliseconds
    for (let i=0;i<list.length;i++){
        const diffDaysEreader= Math.round(Math.abs((list[i].end - list[i].start) / oneDay));
        list[i].day=diffDaysEreader;
        var diffMsEreader=(new Date() - list[i].start)
        var checkMinuteEreader=
            Math.round(((diffMsEreader  % 86400000) % 3600000) / 60000)
            +Math.floor(diffMsEreader / 86400000)*24*60+Math.floor((diffMsEreader % 86400000) / 3600000)*60; // minutes
        list[i].minute=checkMinuteEreader<=15?1:0
    }
    total=total[0]["count('product.id')"]
    const nPages=Math.ceil(total/9);
    const page_items=[];

    for (let i=1;i<=nPages;i++){
        const item={
            value:i,
            isActive:i===page,searchpro
        }
        page_items.push(item)
    }
    if (req.session.authenticated!==false){
        const listProductUser=await productmodel.getProductwithUser(req.session.user.id);
        for (let i=0;i<list.length;i++){
            list[i].authenticated=res.locals.authenticated;
            for (let j=0;j<listProductUser.length;j++){
                if (listProductUser[j].product===list[i].id){
                    list[i].checkwl=true;
                }
            }
        }
    }
    res.render("productType/product", {
        products:list,
        empty: list.length === 0,
        layout:'layoutwithCat.hbs',
        page_items,
        prev_value:page-1,
        next_value:page+1,
        can_go_prev:page>1,
        can_go_next:page<nPages,
        searchpro,
    })
})
app.post("/byCat/watchlist",async function (req, res) {
    const ret = await  productmodel.addProtoWL(req.body.id,req.session.user.id);
    const url= req.headers.referer || "/";
    res.redirect(url);
})
app.post("/watchList",async function (req, res) {
    const ret = await  productmodel.delProWL(req.body.id,req.session.user.id);
    const url= req.headers.referer || "/";
    res.redirect(url);
})
function auth(req,res,next){
    if (req.session.authenticated===false){
        req.session.login=false;
        return res.redirect('/login');
    }
    next();
}
app.get("/watchList",auth,async function (req,res){
    var searchpro=req.query.name;
    var page=+req.query.page||1;
    if (page<0) page=1;
    const offset=(page-1)*9;
    let [list,total] =await Promise.all([
        productmodel.getProductInforwithUser(req.session.user.id,9,offset),
        productmodel.totalProductInforwithUser(req.session.user.id)
    ]);
    const oneDay = 24 * 60 * 60 * 1000; // hours*minutes*seconds*milliseconds
    for (let i=0;i<list.length;i++){
        const diffDaysEreader= Math.round(Math.abs((list[i].end - list[i].start) / oneDay));
        list[i].day=diffDaysEreader;
        var diffMsEreader=(new Date() - list[i].start)
        var checkMinuteEreader=
            Math.round(((diffMsEreader  % 86400000) % 3600000) / 60000)
            +Math.floor(diffMsEreader / 86400000)*24*60+Math.floor((diffMsEreader % 86400000) / 3600000)*60; // minutes
        list[i].minute=checkMinuteEreader<=15?1:0
    }
    total=total[0]['count(*)']
    const nPages=Math.ceil(total/9);
    const page_items=[];

    for (let i=1;i<=nPages;i++){
        const item={
            value:i,
            isActive:i===page,searchpro
        }
        page_items.push(item)
    }
    if (req.session.authenticated!==false){
        for (let i=0;i<list.length;i++){
            list[i].authenticated=req.session.authenticated;
            list[i].removewl=true;
        }
    }
    res.render("productType/product", {
        products:list,
        empty: list.length === 0,
        layout:'layoutwithCat.hbs',
        page_items,
        prev_value:page-1,
        next_value:page+1,
        can_go_prev:page>1,
        can_go_next:page<nPages,
        activeWatchlist:true,
        searchpro:"watchlist"
    })
})
export default app;
