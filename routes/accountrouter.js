import express from "express";
import fs from "fs";
import productmodel from "../models/productmodel.js";
import usermodel from "../models/usermodel.js";
import bcrypt from "bcryptjs";
import admin from "../middlewares/admin.mdw.js";
import multer from "multer";
import categorymodel from "../models/categorymodel.js";
import moment from "moment";
import crypt from "../utils/crypt.js";
import mailgu from "mailgun-js/lib/mailgun.js";
import {CAMPAIGN_ID} from "mailgun";

const router = express.Router();
const hashedApi =
  "87188d3dedb0558b49e8baa28b414ee3175caac3e27f94bd73b5fdb0f0651bb206ecb4bfea83a060032bb0ce3fd864db";
const hashedDomain =
  "7dcecb51f53178edd7a6de01581da0b877ac22c459c6599c460cf8a438e5a2e62858b1e92c828e3d257fc9a16afb4a6aff40479f8e45184330814068" +
  "f12e4764";

const DOMAIN = crypt.decrypt(hashedDomain);
const API = crypt.decrypt(hashedApi);
const mailgun = mailgu({ apiKey: API, domain: DOMAIN });

//
router.get("/admin", admin, async function (req, res) {
  if (!req.session.user) return res.redirect("/Error/404");
  req.session.admin = true;

  res.render("./admin");
});

function auth(req, res, next) {
  if (req.session.authenticated === false) {
    req.session.login = false;
    return res.redirect("/login");
  }
  next();
}

router.get("/profile", auth, async function (req, res) {
  if (req.session.user) {
    //   if (req.session.user.privilege != "bidder" && req.session.user.privilege != "seller")
    //       return res.redirect("/404");
  } else return res.redirect("/404");

  var participate = await productmodel.participate(req.session.user.id);
  var wonlist = await productmodel.wonlist(req.session.user.id);
  var checkRate = await productmodel.checkProductAlreadyRate(
    req.session.user.id
  );

  for (let i = 0; i < wonlist.length; i++) {
    for (let j = 0; j < checkRate.length; j++) {
      if (wonlist[i].id === +checkRate[j].product) {
        wonlist[i].checkRate = true;
      }
    }
  }
  var watchlist = await productmodel.watchlist(req.session.user.id);
  // var participate = await productmodel.participate(req.session.user.id);
  // var wonlist = await productmodel.wonlist(req.session.user.id);
  var bidHolder;
  for (let i = 0; i < participate.length; i++) {
    var user1 = await productmodel.findSellerInfor(participate[i].product);
    participate[i].sellername = user1[0].name;
    participate[i].selleremail = user1[0].email;
    bidHolder=await productmodel.bidderHolder(participate[i].product);
    bidHolder=bidHolder[0];
    if (bidHolder.holder===+req.session.user.id) participate[i].holderBid=true
  }
  for (let i = 0; i < wonlist.length; i++) {
    var user2 = await productmodel.findSellerInfor(wonlist[i].id);
    wonlist[i].sellername = user2[0].name;
    wonlist[i].selleremail = user2[0].email;
  }
  for (let i = 0; i < watchlist.length; i++) {
    var user3 = await productmodel.findSellerInfor(watchlist[i].id);
    watchlist[i].sellername = user3[0].name;
    watchlist[i].selleremail = user3[0].email;
  }
  var ratinghistorybidder = await productmodel.ratinghistory(
    req.session.user.id,
    "bidder"
  );
  var ratinghistoryseller = await productmodel.ratinghistory(
    req.session.user.id,
    "seller"
  );
  var user_id=await usermodel.id(req.session.user.id)
  user_id=user_id[0]
  req.session.user=user_id
  if (req.session.user.privilege === "bidder"){
  return res.render("./profile", {
      user: req.session.user,
      name: req.session.user.name,
      email: req.session.user.email,
      priviledge: req.session.user.priviledge,
      address: req.session.user.address,
      dob: req.session.user.birthday,
      watchlist,
      participate,
      wonlist,
      ratinghistorybidder,
      ratinghistoryseller,
      //   var ongoing = await productmodel.ongoing(req.session.user.id);
      //  var soldlist = await productmodel.soldlist(req.session.user.id);
    });
  }
  if (req.session.user.privilege === "admin") {
    return res.render("./profile", {
      user: req.session.user,
      name: req.session.user.name,
      email: req.session.user.email,
      priviledge: req.session.user.priviledge,
      address: req.session.user.address,
      dob: req.session.user.birthday,
      watchlist,
      participate,
      wonlist,
      ratinghistorybidder,
      ratinghistoryseller,
    });
  }

  var ongoing = await productmodel.ongoing(req.session.user.id);
  var checkRate1 = await productmodel.checkProductAlreadyRateSeller(
    req.session.user.id
  );
  var soldlist = await productmodel.soldlist(req.session.user.id);
  for (let i = 0; i < soldlist.length; i++) {
    for (let j = 0; j < checkRate1.length; j++) {
      if (soldlist[i].id === +checkRate1[j].product) {
        soldlist[i].checkRate1 = true;
      }
    }
  }
  var ratinghistoryseller1 = await productmodel.ratinghistorySeller(
    req.session.user.id,
    "seller"
  );

  var ratinghistorybidder1 = await productmodel.ratinghistorySeller(
    req.session.user.id,
    "bidder"
  );
  if (req.session.user.privilege === "seller") {
    return res.render("./profile", {
      user: req.session.user,
      name: req.session.user.name,
      email: req.session.user.email,
      dob: req.session.user.dob,
      priviledge: req.session.user.priviledge,
      address: req.session.user.address,
      watchlist,
      participate,
      wonlist,
      ongoing: ongoing,
      soldlist: soldlist,
      ratinghistorybidder1,
      ratinghistoryseller1,
      //   var ongoing = await productmodel.ongoing(req.session.user.id);
      //  var soldlist = await productmodel.soldlist(req.session.user.id);
    });
  }
  var ongoing = await productmodel.ongoing(req.session.user.id);
  var soldlist = await productmodel.soldlist(req.session.user.id);

  res.render("./profile", {
    user: req.session.user,
    name: req.session.user.name,
    email: req.session.user.email,
    dob: req.session.user.dob,
    priviledge: req.session.user.priviledge,
    address: req.session.user.address,
    participate: participate,
    wonlist: wonlist,
    ongoing: ongoing,
    soldlist: soldlist,
  });
});

router.get("/active/:id", async function (req, res) {
  var user = await usermodel.id(req.params.id);
  if (!user || user.privilege != null) {
    console.log("some thing wrong ");
    return res.redirect("Error/404");
  }
  user = user[0];
  const entity = {
    privilege: "bidder",
    rating: 8,
  };
  const condition = {
    id: user.id,
  };
  await usermodel.update(entity, condition);
  user = await usermodel.id(user.id);
  user = user[0];
  req.session.authenticated = true;
  req.session.user = user;
  res.render("accept");
});

router.post("/upgrade/:id", async function (req, res) {
  const entity = {
    request: "upgrade",
  };
  const condition = { id: req.params.id };
  const rs = await usermodel.update(entity, condition);
  res.redirect("/account/profile");
});
router.get("/editprofile", auth, async function (req, res) {
  const user_f = await usermodel.findUser(req.session.user.id);
  const dob = moment(user_f[0].birthday, "YYYY-MM-DD").format("DD/MM/YYYY");
  res.render("./editprofile", {
    name: user_f[0].name,
    email: user_f[0].email,
    address: user_f[0].address,
    birthday: dob,
  });
});
router.get("/changepassword", auth, async function (req, res) {
  res.render("./changepassword");
});
router.post("/changepassword", auth, async function (req, res, next) {
  const user = await usermodel.findById(req.session.user.id);
  const currentpassword = req.body.currentpassword;
  const newpassword = req.body.newpassword;
  const confirmpassword = req.body.confirmpassword;
  const salt = bcrypt.genSaltSync(10);
  const hash = bcrypt.hashSync(newpassword, salt);
  const rs = bcrypt.compareSync(currentpassword, user.password);
  if (rs === true) {
    usermodel
      .updatePassword(
        {
          password: hash,
        },
        {
          where: { id: req.session.user.id },
        }
      )
      .then(function () {
        usermodel
          .singleByID(req.session.user.id)
          .then((user) => {
            // req.session.user = user;
            // res.locals.user = req.session.user;
            req.session.authenticated = false;
            req.session.admin=false;
            req.session.user = null;
            res.render("./changepassword", {
              success: true,
              newpassword: newpassword,
              confirmpassword: confirmpassword,
            });
          })
          .catch((error) => next(error));
      })
      .catch(function (error) {
        res.json(error);
        console.log("update profile failed!");
      });
  } else {
    res.render("./changepassword", {
      err: true,
      newpassword: newpassword,
      confirmpassword: confirmpassword,
    });
  }
});

router.post("/editprofile", auth, async function (req, res) {
  const dob = moment(req.body.Birthday, "DD/MM/YYYY").format("YYYY-MM-DD");
  usermodel
    .updateNamevsAddressvsDob(
      {
        name: req.body.Name,
        address: req.body.Address,
        birthday: dob,
      },
      {
        where: { id: req.session.user.id },
      }
    )
    .then(function () {
      usermodel
        .singleByID(req.session.user.id)
        .then((user) => {
          req.session.user = user;
          res.locals.user = req.session.user;
          // res.redirect("/account/profile");
          res.render("editprofile",{
            announcement:"Edit Successfully",
            name: user.name,
            address: user.address,
            birthday: moment(user.birthday, "YYYY-MM-DD").format("DD/MM/YYYY"),
            email:user.email
          })
        })
        .catch((error) => next(error));
    })
    .catch(function (error) {
      res.json(error);
      console.log("update profile failed!");
    });
});
router.get("/reminder", async function (req, res) {
  res.render("./reminder");
});

router.get("/accept", async function (req, res) {
  req.session.authenticated = true;
  res.render("./accept");
});

router.post("/upgrade/:id", async function (req, res) {
  const entity = {
    request: "upgrade",
  };
  const condition = { id: req.params.id };
  const rs = await usermodel.update(entity, condition);
  res.redirect("/account/profile");
});
router.get("/editprofile", auth, async function (req, res) {
  const user_f = await usermodel.findUser(req.session.user.id);
  res.render("./editprofile", {
    name: user_f[0].name,
    email: user_f[0].email,
    address: user_f[0].address,
  });
});
router.get("/changepassword", auth, async function (req, res) {
  res.render("./changepassword");
});
router.post("/changepassword", auth, async function (req, res, next) {
  const user = await usermodel.findById(req.session.user.id);
  const currentpassword = req.body.currentpassword;
  const newpassword = req.body.newpassword;
  const confirmpassword = req.body.confirmpassword;
  const salt = bcrypt.genSaltSync(10);
  const hash = bcrypt.hashSync(newpassword, salt);
  const rs = bcrypt.compareSync(currentpassword, user.password);
  if (rs === true) {
    usermodel
      .updatePassword(
        {
          password: hash,
        },
        {
          where: { id: req.session.user.id },
        }
      )
      .then(function () {
        usermodel
          .singleByID(req.session.user.id)
          .then((user) => {
            req.session.user = user;
            res.locals.user = req.session.user;
            res.render("./changepassword", {
              success: true,
              newpassword: newpassword,
              confirmpassword: confirmpassword,
            });
          })
          .catch((error) => next(error));
      })
      .catch(function (error) {
        res.json(error);
        console.log("update profile failed!");
      });
  } else {
    res.render("./changepassword", {
      err: true,
      newpassword: newpassword,
      confirmpassword: confirmpassword,
    });
  }
});

router.post("/editprofile", auth, async function (req, res) {
  usermodel
    .updateNamevsAddress(
      {
        name: req.body.Name,
        address: req.body.Address,
      },
      {
        where: { id: req.session.user.id },
      }
    )
    .then(function () {
      usermodel
        .singleByID(req.session.user.id)
        .then((user) => {
          req.session.user = user;
          res.locals.user = req.session.user;
          res.redirect("/account/profile");
        })
        .catch((error) => next(error));
    })
    .catch(function (error) {
      res.json(error);
      console.log("update profile failed!");
    });
});
router.get(
  "/reviewpost/:seller/:productid/:like",
  auth,
  async function (req, res) {
    let rating = await productmodel.getRating(req.params.seller);
    rating = rating[0].rating;
    let countLikeBidder = await productmodel.countLikeBidder(
      req.params.seller,
      1
    );
    countLikeBidder = countLikeBidder[0].count;
    let countDisLikeBidder = await productmodel.countLikeBidder(
      req.params.seller,
      0
    );
    countDisLikeBidder = countDisLikeBidder[0].count;
    let percentLike =
      countLikeBidder / parseFloat(countLikeBidder + countDisLikeBidder);
    let percentDisLike =
      countDisLikeBidder / parseFloat(countLikeBidder + countDisLikeBidder);
    let u_ser = await productmodel.findSellerInfor(req.params.productid);
    let name = u_ser[0].name;
    var today = new Date();
    res.render("reviewpost", {
      rating,
      countLikeBidder,
      countDisLikeBidder,
      percentLike: percentLike * 100,
      percentDisLike: percentDisLike * 100,
      name,
      today,
      seller: req.params.seller,
      productid: req.params.productid,
      like: req.params.like,
    });
  }
);
router.post(
  "/reviewpost/:seller/:productid/:like",
  auth,
  async function (req, res) {
    const sellerid = req.params.seller;
    const productid = req.params.productid;
    const like = req.params.like === "like" ? 1 : 0;
    const comment = req.body.comment;
    const bidderid = req.session.user.id;
    var entity = {
      product: productid,
      bidder: bidderid,
      seller: sellerid,
      like: like,
      comment: comment,
      sender: "bidder",
      time: new Date(),
    };
    await productmodel.insertRatingBidder(entity);
    let likeseller = await productmodel.countLikeBidder(sellerid, 1);
    let totalrating = await productmodel.countRateBidder(sellerid);
    likeseller = likeseller[0].count;
    totalrating = totalrating[0].count;
    const score = (likeseller / parseFloat(totalrating)) * 10;
    entity = {
      rating: score.toFixed(2),
    };
    await usermodel.updateRating(sellerid, entity);
    res.redirect("/account/profile");
  }
);

router.get("/upload", auth, async function (req, res) {
  if (req.session.user) {
    if (req.session.user.privilege != "seller") return res.redirect("/404");
  } else return res.redirect("/404");
  let list = await categorymodel.all();
  res.render("product-add", {
    category: list,
  });
});

router.post("/upload", auth, async function (req, res) {
  if (req.session.user) {
    if (req.session.user.privilege != "seller") return res.redirect("/404");
  } else return res.redirect("/404");
  let renew1= req.body.renew1;
  let allowbid =req.body.allowbid;
  let checkrenew=0;
  let checkallowbid=0;
  if (renew1==="yes"){
    checkrenew =1;
  }
  if (allowbid==="yes"){
    checkallowbid =1;
  }

  let list = await categorymodel.all();
  const ID_user = req.session.user.id;
  let incre = parseFloat(req.body.Incre);
  if (incre < 100000) {
    incre = 100000;
  }

  const Amount = (await productmodel.countCat()) + 1;
  const entity = {
    id: Amount,
    name: req.body.Name,
    seller: req.session.user.id,
    start: moment().format("YYYY-MM-DD hh:mm:ss"),
    end: moment().add(7, "days").format("YYYY-MM-DD hh:mm:ss"),
    cap: req.body.Reservation,
    current: req.body.start,
    increment: incre,
    // holder: req.session.user.id,
    //  info: req.session.user.name,
    bids: 5,
    description: req.body.Des,
    category: req.body.cate,
    status: "bidding",
    renew: checkrenew,
    allow: checkallowbid
  };
  const temp2 = await usermodel.add_Product(entity);
  const catIdAdded = entity.id;
  const CatePro = entity.category;
  res.redirect(`/account/upload/img/${catIdAdded}/${CatePro}`);
});

router.get("/upload/img/:catId/:proId", auth, async (req, res) => {
  res.render("product-add-img");
});

router.post("/upload/img/:catId/:proId", async function (req, res) {
  const temp = req.params.proId;
  const temp1 = await productmodel.countCatById(temp);
  const cate = productmodel.selectCate(temp);
  const folderName = "./public/imgs/" + cate + "/" + temp1;
  const folderAdd = "/public/imgs/" + cate + "/" + temp1 + "/";
  const ID_product = req.params.catId;

  try {
    if (!fs.existsSync(folderName)) {
      fs.mkdirSync(folderName);
    }
  } catch (err) {}

  const storage = multer.diskStorage({
    destination: function (req, file, cb) {
      cb(null, folderName);
    },
    filename: function (req, file, cb) {
      cb(null, file.originalname);
    },
  });

  const upload = multer({ storage });
  upload.array("fuMain", 5)(req, res, async function (err) {
    if (err) {
      console.error(err);
    } else {
      let i = 1;
      let list_img = [];
      fs.readdirSync(folderName).forEach((file) => {
        const extension = file.split(".").pop();
        fs.renameSync(
          folderName + "/" + file,
          folderName + "/" + i + "." + extension
        );
        list_img[i] = folderAdd + i + "." + extension;
        i++;
      });

      const size = i;
      const add_img = {
        image: list_img[1],
      };
      const add_db = await usermodel.add_image(add_img, ID_product);
      for (let j = 1; j < size; j++) {
        let temp_img = {
          image: list_img[j],
          product: ID_product,
        };
        const add_db_img = await usermodel.add_img_table(temp_img);
      }
      return res.redirect("/account/profile");
    }
  });
});
router.get("/edit/:id", auth, async (req, res) => {
  res.render("description-edit");
});
router.post("/edit/:id", async function (req, res) {
  const updateDes = req.body.Des;
  const ID_Des = req.params.id;
  const list = await productmodel.detail(ID_Des);
  const time = moment().format("YYYY-MM-DD");
  const append_Des =
    list[0].description + "\n" + "\n" + time + "\n" + updateDes;
  const entity = {
    description: append_Des,
  };
  const temp = await usermodel.append_Des(entity, ID_Des);
  return res.redirect("/account/profile");
});

router.post("/delete/:id", async function (req, res) {
  const ID_His = req.params.id;
  const list = await productmodel.findHistory(ID_His);
  const k = parseInt(list[0].offer) - parseInt(list[0].offer) / 100;
  const id_del = list[0].product;
  const del = await productmodel.delProBidder(
    list[0].user,
    list[0].offer,
    list[0].product
  );
  const addreject= await  productmodel.addRejectBid(list[0].product, list[0].user);
  //reject bidder by email

  let product_name=await productmodel.detail(list[0].product)
    product_name=product_name[0].name
    let user_email=await  usermodel.singleByID(list[0].user)
    let user_name=user_email.name
    user_email=user_email.email
    const data = {
      from: 'GPA Team <HCMUS@fit.com>',
      to: user_email,
      subject: 'Online Auction',
      text: `Hi ${user_name}\nYour product:${product_name} bid be rejected by seller
      \n\nThank you for joining us!\nHappy bidding!\nSent: ${moment()}`
    };
    mailgun.messages().send(data);

  if (list[1] != null) {
    const list_name = await usermodel.findName(list[1].user);
    const name = list_name[0].name;
    const entity = {
      holder: list[1].user,
      info: name,
      current: list[1].offer,
    };

    const update_bidder = await productmodel.updateNewBidder(id_del, entity);
  } else {
    const entity = {
      holder: "",
      info: "",
      current: k,
    };
    const update_bidder = await productmodel.updateNewBidder(id_del, entity);
  }
  const url = req.headers.referer || "/";
  res.redirect(url);
});
router.get(
  "/reviewpost/seller/:holder/:productid/:like",
  auth,
  async function (req, res) {
    let rating = await productmodel.getRating(req.params.holder);
    rating = rating[0].rating;
    let countLikeSeller = await productmodel.countLikeSeller(
      req.params.holder,
      1
    );
    countLikeSeller = countLikeSeller[0].count;
    let countDisLikeSeller = await productmodel.countLikeSeller(
      req.params.holder,
      0
    );
    countDisLikeSeller = countDisLikeSeller[0].count;
    let percentLike =
      countLikeSeller / parseFloat(countLikeSeller + countDisLikeSeller);
    let percentDisLike =
      countDisLikeSeller / parseFloat(countLikeSeller + countDisLikeSeller);
    let u_ser = await productmodel.findHolderInfor(req.params.productid);
    let name = u_ser[0].name;
    var today = new Date();
    res.render("reviewpost-seller", {
      rating,
      countLikeSeller,
      countDisLikeSeller,
      percentLike: percentLike * 100,
      percentDisLike: percentDisLike * 100,
      name,
      today,
      bidder: req.params.holder,
      productid: req.params.productid,
      like: req.params.like,
    });
  }
);
router.post(
  "/reviewpost/seller/:holder/:productid/:like",
  auth,
  async function (req, res) {
    const sellerid = req.session.user.id;
    const productid = req.params.productid;
    const like = req.params.like === "like" ? 1 : 0;
    const comment = req.body.comment;
    const bidderid = req.params.holder;
    var entity = {
      product: productid,
      bidder: bidderid,
      seller: sellerid,
      like: like,
      comment: comment,
      sender: "seller",
      time: new Date(),
    };
    await productmodel.insertRatingSeller(entity);
    let likebidder = await productmodel.countLikeSeller(bidderid, 1);
    let totalrating = await productmodel.countRateSeller(bidderid);
    likebidder = likebidder[0].count;
    totalrating = totalrating[0].count;
    const score = (likebidder / parseFloat(totalrating)) * 10;
    entity = {
      rating: score.toFixed(2),
    };
    await usermodel.updateRating(bidderid, entity);
    res.redirect("/account/profile");
  }
);
router.post("/cancel/:id", async function (req, res) {
  const IDpro_cancel = req.params.id;
  const list = await productmodel.getWinner(IDpro_cancel);
  const IDuser_cancel= list[0].holder;
  const add_deal = await productmodel.addCancelDeal(IDpro_cancel,IDuser_cancel);
  const dislike = 0;
  const sellerid =list[0].seller;
  const comment = "Winner doesnt pay this deal"
  var entity = {
    product: IDpro_cancel,
    bidder: IDuser_cancel,
    seller: sellerid,
    like: dislike,
    comment: comment,
    sender: "seller",
    time: new Date(),
  };
  await productmodel.insertRatingSeller(entity);
  let likebidder = await productmodel.countLikeSeller(IDuser_cancel, 1);
  let totalrating = await productmodel.countRateSeller(IDuser_cancel);
  likebidder = likebidder[0].count;
  totalrating = totalrating[0].count;
  const score = (likebidder / parseFloat(totalrating)) * 10;
  entity = {
    rating: score.toFixed(2),
  };
  await usermodel.updateRating(IDuser_cancel, entity);
  const url = req.headers.referer || "/";
  res.redirect(url);
});
export default router;
