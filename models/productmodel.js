import db from "../utils/db.js";
import mysql from "mysql2";

export default {
  findCatById(catID) {
    return db("product").where("category", catID);
  },
  findById(catID) {
    return db("product").where("id", catID);
  },
  async countCatById(catID) {
    const list = await db("product")
      .where("category", catID)
      .count({ amount: "id" });
    return list[0].amount;
  },
  async countCat() {
    const list = await db("product").count({ amount: "id" });
    return list[0].amount;
  },
  selectCate(Cate) {
    if (Cate == 1) return "phone";
    if (Cate == 2) return "laptop";
    if (Cate == 3) return "tablet";
    if (Cate == 4) return "smartwatch";
    if (Cate == 5) return "ereader";
  },
  findPageById(catID, limit, offset) {
    return db("product").where("category", catID).limit(limit).offset(offset);
  },
  findTop5ProHighest() {
    return db("product").limit(5).offset(0).orderBy("current", "DESC");
  },
  findAll() {
    return db("product");
  },
  findMobile() {
    return db("product").where("category", 1);
  },
  findLaptop() {
    return db("product").where("category", 2);
  },
  findSmartWatch() {
    return db("product").where("category", 4);
  },
  findTablet() {
    return db("product").where("category", 3);
  },
  findEreader() {
    return db("product").where("category", 5);
  },
  findTop5ProMostBids() {
    return db("product").limit(5).offset(0).orderBy("bids", "DESC");
  },
  findTop5ProInstance() {
    return db("product").limit(5).offset(0).orderBy("end", "ASC");
  },
  findHistory(catId) {
    return db("history").where("product", catId).orderBy("offer", "DESC");
  },
  delProBidder(user, offer, id) {
    return db("history").where({ user: user, offer: offer, product: id }).del();
  },
  updateNewBidder(id, entity) {
    return db("product").where({ id: id }).update(entity);
  },
  async find() {
    const ob = await db("product").where("id", 1);
    return ob;
  },
  detail(id) {
    const list = db("product").where("id", id);
    return list;
  },
  related(category,id) {
    return db("product")
      .limit(5)
      .where("category", category).whereNot('id',id)
      .offset(0)
      .orderBy("start", "DESC");
  },
  async product(product) {
    return db("image").where("product", product);
    const ob = await db("product").where("id", 1);
    return ob;
  },
  pageByCat(catID, limit, offset) {
    if (catID == +0)
      return db.select("*").from("product").limit(limit).offset(offset);
    else
      return db
        .select("*")
        .from("product")
        .where("category", catID)
        .limit(limit)
        .offset(offset);
  },
  totalOfCat(catID) {
    if (catID == +0) return db("product").count();
    else return db("product").count().where("category", catID);
  },
  searchProduct(name, limit, offset) {
    return db("product")
      .where("name", "like", `%${name}%`)
      .limit(limit)
      .offset(offset);
  },
  async searchFullText(proName, limit, offset) {
    const sql = `select * FROM product WHERE MATCH(name) AGAINST("${proName}") or MATCH(description) AGAINST("${proName}") 
LIMIT ${limit} OFFSET ${offset}`;
    const raw_data = await db.raw(sql);
    return raw_data[0];
  },
  async totalSearchFullText(proName) {
    const sql = `select count('product.id') FROM product WHERE MATCH(name) AGAINST("${proName}") or MATCH(description) AGAINST("${proName}")`;
    const raw_data = await db.raw(sql);
    return raw_data[0];
  },
  totalofSearchProduct(name) {
    return db("product").count().where("name", "like", `%${name}%`);
  },
  orderedByPrice(limit, offset) {
    return db("product").orderBy("current").limit(limit).offset(offset);
  },
  totalorderByPrice() {
    return db("product").count();
  },
  orderedByTime(limit, offset) {
    return db("product").orderBy("end").limit(limit).offset(offset);
  },
  totalorderByTime() {
    return db("product").count();
  },
  async refresh(_) {
    return db.Refresh();
  },
  async page(offset) {
    return db("product").limit(24).offset(offset);
  },
  // total: async _ => {
  //   const row = await db.select( `select * from product`);
  //   return row.length;
  // },
  async total(_) {
    const row = await db("product");
    return row.length;
  },
  addProtoWL(id, user) {
    return db("watchlist").insert({ user: user, product: id });
  },
  addRejectBid(id, user) {
    return db("reject").insert({ userid: user, productid: id });
  },
  addCancelDeal(id, user) {
    return db("canceldeal").insert({ userid: user, productid: id });
  },
  getWinner(id) {
    return db("product").where({ id: id });
  },
  getProductwithUser(user) {
    return db("watchlist").select("product").where("user", user);
  },
  getProductInforwithUser(user, limit, offset) {
    return db("product")
      .join("watchlist", "product.id", "=", "watchlist.product")
      .where("watchlist.user", user)
      .limit(limit)
      .offset(offset);
  },
  totalProductInforwithUser(user, limit, offset) {
    return db("product")
      .count()
      .join("watchlist", "product.id", "=", "watchlist.product")
      .where("watchlist.user", user)
      .limit(limit)
      .offset(offset);
  },
  delProWL(id, user) {
    return db("watchlist").where({ product: id, user: user }).del();
  },

  history(id) {
    return db("history")
      .select("user.name", "history.offer", "history.time")
      .where("history.product", id)
      .orderBy("time", "asc")
      .join("user", "user.id", "=", "history.user");
  },
  async countByCat(category) {
    const row = await db("product").where("category", category);
    return row.length;
  },
  delete(id) {
    return db("product").where("id", id).del();
  },
  async countByUser(id) {
    const row = await db("product").where("seller", id);
    return row.length;
  },
  watchlist(id) {
    return db("product")
      .join("watchlist", "product.id", "=", "watchlist.product")
      .where("watchlist.user", id);
  },
  participate(id) {
    return db("product")
      .join("history", "product.id", "=", "history.product")
      .where({ "product.status": "bidding", "history.user": id });
  },
  wonlist(id) {
    return db("product").where({ holder: id, status: "sold" });
  },
  getRejectlist(user, id) {
    return db("reject").where({ userid: user, productid: id });
  },
  ongoing(id) {
    return db("product").where({ seller: id, status: "bidding" });
  },
  soldlist(id) {
    return db("product").where({ seller: id, status: "sold" });
  },
  holder(id) {
    return db("user")
      .select("user.name", "user.email")
      .join("history", "user.id", "history.user")
      .where("history.product", id)
      .orderBy("history.offer", "desc")
      .limit(1);
  },
  async bid(entity) {
    const sql = `select history.offer as price, bidder.name as bidder, bidder.email as bidderemail, seller.name as seller, seller.email as selleremail, product.name, product.increment from history, user as bidder, product, user as seller where history.product=${entity.product} and history.user=${entity.user} and product.id=history.product and bidder.id=history.user and product.seller=seller.id order by history.offer desc limit 1`;
    const raw_data = await db.raw(sql);
    return raw_data[0];
  },
  async xfactor(entity) {
    return db("automation")
      .join("user", "user.id", "automation.user")
      .where("automation.product", entity.product)
      .andWhere("automation.offer", ">", entity.offer)
      .orderBy("automation.offer", "desc")
      .limit(1);
  },
  insertRatingBidder(entity) {
    return db("rating").insert(entity);
  },
  insertRatingSeller(entity) {
    return db("rating").insert(entity);
  },
  findSellerInfor(proID) {
    return db("user")
      .select("user.name", "user.email")
      .join("product", "product.seller", "=", "user.id")
      .where("product.id", proID);
  },
  findHolderInfor(proID) {
    return db("user")
      .select("user.name", "user.email")
      .join("product", "product.holder", "=", "user.id")
      .where("product.id", proID);
  },
  getRating(id) {
    return db("user").select("user.rating").where("user.id", id);
  },
  countLikeBidder(id, like) {
    return db("rating")
      .count("id as count")
      .where({
        "rating.seller": id,
        "rating.like": like,
        "rating.sender": "bidder",
      });
  },
  countRateBidder(id) {
    return db("rating")
      .count("id as count")
      .where({ "rating.seller": id, "rating.sender": "bidder" });
  },
  countLikeSeller(id, like) {
    return db("rating")
      .count("id as count")
      .where({
        "rating.bidder": id,
        "rating.like": like,
        "rating.sender": "seller",
      });
  },
  countRateSeller(id) {
    return db("rating")
      .count("id as count")
      .where({ "rating.bidder": id, "rating.sender": "seller" });
  },
  checkProductAlreadyRate(id) {
    return db("rating")
      .select("rating.product")
      .where({ "rating.bidder": id, "rating.sender": "bidder" });
  },
  checkProductAlreadyRateSeller(id) {
    return db("rating")
      .select("rating.product")
      .where({ "rating.seller": id, "rating.sender": "seller" });
  },
  ratinghistory(userid, sender) {
    return db("rating")
      .select(
        "user.name as sellername",
        "product.name",
        "rating.time",
        "rating.comment"
      )
      .join("product", "product.id", "rating.product")
      .where({ "rating.sender": sender, "rating.bidder": userid })
      .join("user", "product.seller", "user.id");
  },
  ratinghistorySeller(userid, sender) {
    return db("rating")
      .select(
        "user.name as biddername",
        "product.name",
        "rating.time",
        "rating.comment"
      )
      .join("product", "product.id", "rating.product")
      .where({ "rating.sender": sender, "rating.seller": userid })
      .join("user", "product.holder", "user.id");
  },
  updateTimePro(id) {
    return db("product")
      .update("status", "sold")
      .where({ id: id, status: "bidding" });
  },
  expiredtimePro(id) {
    return db("product")
      .update("status", "123123123123")
      .where({ id: id, status: "bidding" });
  },
  updateHistoryBidding(entity) {
    return db("history").insert(entity);
  },
  getProRenew() {
    return db("product").where("status", "bidding");
  },
  updateProRenew(productid, datetime) {
    return db("product")
      .where({ status: "bidding", id: productid })
      .update("end", datetime);
  },
  updateRenewCondition(productid) {
    return db("product").update("renew", 0).where("id", productid);
  },
  test() {
    let config = {
      host: "127.0.0.1",
      port: 3306,
      user: "root",
      password: "",
      database: "auction",
    };
    let connection = mysql.createConnection(config);

    let sql = `CALL Refresh()`;

    connection.query(sql, true, (error, results, fields) => {
      if (error) {
        return console.error(error.message);
      }
    });

    connection.end();
  },
  findProductSoldedWithMailing() {
    return db("product").where({ status: "sold" });
  },
  findProductExpiredWithMailing() {
    return db("product").where({ status: "expired" });
  },
  findAutoHighest(productID) {
    return db("automation")
      .max("offer", { as: "maxoffer" })
      .where("product", "=", productID);
  },
  findUserHighestAuto(offer, productID) {
    return db("automation").where({ product: productID, offer: offer });
  },
  findUserHighestHistory(productID) {
    return db("history")
      .where("product", productID)
      .orderBy("offer", "desc")
      .limit(1);
  },
  addMailWon(entity) {
    return db("mailwon").insert(entity);
  },
  getcheckMailWon(email, productid) {
    return db("mailwon").where({ email: email, productid: productid });
  },
  updateCheckMailWon(email, productid) {
    return db("mailwon")
      .where({ email: email, productid: productid })
      .update("check", 1);
  },
  getAllowProduct(productid) {
    return db("product").select("allow").where("id", productid);
  },
  addAutoNew(entity) {
    return db("automation").insert(entity);
  },
  getCategories() {
    return db("category").select("name");
  },
  getCategoriesID(id) {
    return db("category").select("name").where("id",id);
  },
  bidderHolder(id){
    return db("product").select("product.holder").where("product.id",id)
  },
  userBidProduct(productid){
    return db("history").select("user.name","user.id").where("product",productid)
        .join("user","history.user","user.id")
  }
};
