import { dirname } from "path";
import { fileURLToPath } from "url";
import productmodel from "../models/productmodel.js";
const __dirname = dirname(fileURLToPath(import.meta.url));
import productRoute from "../routes/Product/product.js";
import userRoute from "../routes/indexrouter.js";
import accountrouter from "../routes/accountrouter.js";
import detailrouter from "../routes/detailrouter.js";
import adminUserRoute from "../routes/admin.user.router.js"
import adminCategoryRoute from "../routes/admin.category.router.js"
import adminProductRoute from "../routes/admin.product.router.js"
import usermodel from "../models/usermodel.js";
//routes
export default function (app) {
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
  });
  app.use("/product", productRoute);
  //
  app.use("/user", userRoute);
  app.use("/", userRoute);
  app.use("/account", accountrouter);
  app.use("/detail", detailrouter);
  app.use("/admin/user",adminUserRoute)
  app.use("/admin/category",adminCategoryRoute)
  app.use("/admin/product",adminProductRoute)
  app.use(function (req, res) {
    res.render("Error/404", { layout: false });
  });
  app.use(function (err, req, res, next) {
    console.error(err.stack);
    res.render("Error/500", { layout: false });
  });
}
