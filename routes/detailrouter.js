import express from "express";
import moment from "moment";
import productmodel from "../models/productmodel.js";
import mailgu from "mailgun-js/lib/mailgun.js";

import usermodel from "../models/usermodel.js";
import crypt from "../utils/crypt.js";
import numeral from "numeral";

const router = express.Router();
const hashedApi =
  "87188d3dedb0558b49e8baa28b414ee3175caac3e27f94bd73b5fdb0f0651bb206ecb4bfea83a060032bb0ce3fd864db";
const hashedDomain =
  "7dcecb51f53178edd7a6de01581da0b877ac22c459c6599c460cf8a438e5a2e62858b1e92c828e3d257fc9a16afb4a6aff40479f8e45184330814068" +
  "f12e4764";

const DOMAIN = crypt.decrypt(hashedDomain);
const API = crypt.decrypt(hashedApi);
const mailgun = mailgu({ apiKey: API, domain: DOMAIN });

router.get("/:id", async function (req, res) {
  // await productmodel.test()
  let product = await productmodel.detail(req.params.id);
  if (product.length === 0) return res.redirect("/404");
  product = product[0];
  if (product.status == "sold") product.statuscheck = true;
  else product.statuscheck = false;
  product.sum_ = product.current + product.increment;
  let related = await productmodel.related(product.category,product.id);
  let holder = await usermodel.id(product.holder);
  holder = holder[0];

  let seller = await usermodel.id(product.seller);
  seller = seller[0];
  let a = false;
  let checkRating = true;
  let checkReject = true;
  var getBids = -1;
  if (req.session.user) {
    const listReject = await productmodel.getRejectlist(
      req.session.user.id,
      req.params.id
    );
    if (listReject[0] != null) {
      checkReject = false;
    }
    if (req.session.user.id === +seller.id) a = true;
    let usercurrent = await usermodel.id(req.session.user.id);
    usercurrent = usercurrent[0];
    let rateUserCurrent = usercurrent.rating;
    if (rateUserCurrent < 8) checkRating = false;
    getBids = await usermodel.countNumberofBid_bidder(req.session.user.id);
    getBids = getBids[0];
    getBids = getBids.countid;
  }
  var checkAllow = await productmodel.getAllowProduct(req.params.id);
  checkAllow = checkAllow[0];
  checkAllow = checkAllow.allow;
  if (checkAllow === +1) {
    checkRating = true;
  }
  const image = await productmodel.product(product.id);
  const mainimage = {
    image: product.image,
  };
  image.unshift(mainimage);
  for (let i = 0; i < image.length; i++) image[i].stt = i;
  //let announce;
  let history = await productmodel.history(req.params.id);
  //
  //if (req.session.announce) {
  //    announce = req.session.announce;
  //    delete req.session.announce;
  //}
  //else
  //    announce = null;
  if (req.session.authenticated !== false) {
    const listProductUser = await productmodel.getProductwithUser(
      req.session.user.id
    );
    for (let i = 0; i < listProductUser.length; i++) {
      if (listProductUser[i].product === product.id) {
        product.checkwl = true;
      }
    }
  }
  if ((new Date().getTime()-product.start.getTime()) < 60000*15){
    product.minute=true
  }
  var category=await productmodel.getCategoriesID(product.category)
  category=category[0]
  category=category.name
  var userBidProduct=await productmodel.userBidProduct(req.params.id)
  if (product.holder===+req.session.user.id) product.holderBid=true
  for (let i=0;i<related.length;i++){
    if (related[i].holder===+req.session.user.id) related[i].holderBid=true
  }
  req.session.save(function () {
    return res.render("./detail", {
      check: a,
      product: product,
      holder: holder,
      seller: seller,
      related: related,
      image: image,
      category,
      //path: path,
      //  prepath: prepath,
      //image: image,
      //announce: announce,
      userBidProduct,
      history: history,
      checkRating,
      checkAllow,
      checkReject,
    });
  });
});
router.get("/rating/seller/:id", async function (req, res) {
  var sellerid=req.params.id
  var ratinglist = await usermodel.userratinglist(sellerid);
  for (let i=0;i<ratinglist.length;i++) ratinglist[i].stt=i+1;
res.render("./ratingTable",{
    ratinglist: ratinglist
  })
})
router.get("/rating/bidder/:id", async function (req, res) {
  var sellerid=req.params.id
  var ratinglist = await usermodel.bidderratinglist(sellerid);
  for (let i=0;i<ratinglist.length;i++) ratinglist[i].stt=i+1;
  res.render("./ratingTable",{
    ratinglist: ratinglist
  })
})
router.post("/:id", async function (req, res) {
  // await productmodel.UpdateProduct(req.params.id);
  var product = await productmodel.detail(req.params.id);
  product = product[0];
  var offer_body = req.body.offer;

  offer_body = offer_body.substr(0, offer_body.length - 2);

  offer_body = offer_body.replaceAll(",", ".");
  offer_body = offer_body.replaceAll(".", "");

  var entity = {
    user: req.session.user.id,
    offer: offer_body,
    product: req.params.id,
  };

  if (product.status == "bidding") {
    if (entity.offer >= product.cap && product.cap > 0) {
      await usermodel.bid(entity);
      var enti = {
        user: req.session.user.id,
        product: req.params.id,
      };
      var bid_ding = await productmodel.bid(enti);
      bid_ding = bid_ding[0];
      var dataa = {
        from: "GPA Team<HCMUS@fit.com>",
        to: bid_ding.bidderemail,
        subject: "Online Auction",
        text: `Hi ${bid_ding.bidder},\nCongratulations!\nYou've won ${numeral(
          bid_ding.price
        ).format("0,0")}đ for ${
          bid_ding.name
        }.\n\nThank you for joining us!\nHappy bidding!\nSent: ${moment()}`,
      };
      mailgun.messages().send(dataa);

      dataa = {
        from: "GPA Team<HCMUS@fit.com>",
        to: bid_ding.selleremail,
        subject: "Online Auction",
        text: `Hi ${bid_ding.seller},\nCongratulations!\nYour product ${
          bid_ding.name
        } has been bought for ${numeral(bid_ding.price).format(
          "0,0"
        )}đ.\n\nThank you for joining us!\nHappy selling!\nSent: ${moment()}`,
      };
      mailgun.messages().send(dataa);
    } else {
      var maxAuto = await productmodel.findAutoHighest(entity.product);
      maxAuto = maxAuto[0];
      if (maxAuto.maxoffer != null) {
        var maxauto_ = parseInt(maxAuto.maxoffer);
        var user_auto = await productmodel.findUserHighestAuto(
          maxauto_,
          entity.product
        );
        user_auto = user_auto[0];
        var offer_ = parseInt(entity.offer);
        var incre_ = parseInt(product.increment);
      } else {
        var maxauto_ = -1;
        var offer_ = 0;
        var incre_ = -2;
      }
      if (
        maxauto_ >= offer_ &&
        maxauto_ - offer_ >= 0 &&
        maxauto_ - offer_ <= incre_
      ) {
        var e = {
          user: req.session.user.id,
          offer: maxauto_,
          product: req.params.id,
        };
        var e1 = {
          user: user_auto.user,
          offer: maxauto_,
          product: req.params.id,
        };
        await productmodel.updateHistoryBidding(e1);
        await productmodel.updateHistoryBidding(e);
        var eti = {
          user: req.session.user.id,
          product: req.params.id,
        };
        var bid_ding = await productmodel.bid(eti);
        bid_ding = bid_ding[0];
        var dataa_ = {
          from: "GPA Team<HCMUS@fit.com>",
          to: bid_ding.bidderemail,
          subject: "Online Auction",
          text: `Hi ${
            bid_ding.bidder
          },\nCongratulations!\nYou've offered ${numeral(bid_ding.price).format(
            "0,0"
          )}đ for ${
            bid_ding.name
          } successfully, but not hold this product.\n\nThank you for joining us!\nHappy bidding!\nSent: ${moment()}`,
        };
        mailgun.messages().send(dataa_);

        dataa_ = {
          from: "GPA Team<HCMUS@fit.com>",
          to: bid_ding.selleremail,
          subject: "Online Auction",
          text: `Hi ${bid_ding.seller},\nCongratulations!\nYour product ${
            bid_ding.name
          } has been offered for ${numeral(bid_ding.price).format(
            "0,0"
          )}đ.\n\nThank you for joining us!\nHappy selling!\nSent: ${moment()}`,
        };
        mailgun.messages().send(dataa_);
      } else {
        var exholder = await productmodel.holder(req.params.id);
        await usermodel.automated(entity);
        entity = {
          product: req.params.id,
          user: req.session.user.id,
        };

        var bidding = await productmodel.bid(entity);
        bidding = bidding[0];
        if (bidding == null) {
          entity = {
            user: req.session.user.id,
            product: req.params.id,
            offer: product.current + product.increment,
            time: new Date(),
          };
          var newE = {
            user: req.session.user.id,
            product: req.params.id,
            offer: req.body.offer,
          };
          await productmodel.updateHistoryBidding(entity);
          bidding = await productmodel.bid(entity);
          bidding = bidding[0];
          var data = {
            from: "GPA Team<HCMUS@fit.com>",
            to: bidding.bidderemail,
            subject: "Online Auction",
            text: `Hi ${
              bidding.bidder
            },\nCongratulations!\nYou've offered ${numeral(
              bidding.price
            ).format("0,0")}đ for ${
              bidding.name
            } successfully.\n\nThank you for joining us!\nHappy bidding!\nSent: ${moment()}`,
          };
          mailgun.messages().send(data);

          data = {
            from: "GPA Team<HCMUS@fit.com>",
            to: bidding.selleremail,
            subject: "Online Auction",
            text: `Hi ${bidding.seller},\nCongratulations!\nYour product ${
              bidding.name
            } has been offered for ${numeral(bidding.price).format(
              "0,0"
            )}đ.\n\nThank you for joining us!\nHappy selling!\nSent: ${moment()}`,
          };
          mailgun.messages().send(data);
        } else {
          product = await productmodel.detail(req.params.id);
          product = product[0];
          var data = {
            from: "GPA Team<HCMUS@fit.com>",
            to: bidding.bidderemail,
            subject: "Online Auction",
            text: `Hi ${
              bidding.bidder
            },\nCongratulations!\nYou've offered ${numeral(
              bidding.price
            ).format("0,0")}đ for ${
              bidding.name
            } successfully, but not hold this product.\n\nThank you for joining us!\nHappy bidding!\nSent: ${moment()}`,
          };
          if (product.holder !== req.session.user.id) {
            mailgun.messages().send(data);
          } else {
            data = {
              from: "GPA Team<HCMUS@fit.com>",
              to: bidding.bidderemail,
              subject: "Online Auction",
              text: `Hi ${
                bidding.bidder
              },\nCongratulations!\nYou've offered ${numeral(
                bidding.price
              ).format("0,0")}đ and holding for ${
                bidding.name
              } successfully.\n\nThank you for joining us!\nHappy bidding!\nSent: ${moment()}`,
            };
            mailgun.messages().send(data);
          }
          var highestBid = await productmodel.findAutoHighest(req.params.id);
          highestBid = highestBid[0];
          if (bidding.price >= highestBid.maxoffer) {
            data = {
              from: "GPA Team<HCMUS@fit.com>",
              to: bidding.selleremail,
              subject: "Online Auction",
              text: `Hi ${bidding.seller},\nCongratulations!\nYour product ${
                bidding.name
              } has been offered for ${numeral(bidding.price).format(
                "0,0"
              )}đ.\n\nThank you for joining us!\nHappy selling!\nSent: ${moment()}`,
            };
            mailgun.messages().send(data);
          } else {
            data = {
              from: "GPA Team<HCMUS@fit.com>",
              to: bidding.selleremail,
              subject: "Online Auction",
              text: `Hi ${bidding.seller},\nCongratulations!\nYour product ${
                bidding.name
              } has been offered for ${numeral(bidding.price).format(
                "0,0"
              )}đ.\n\nThank you for joining us!\nHappy selling!\nSent: ${moment()}`,
            };
            mailgun.messages().send(data);
            var otherbid = await productmodel.findUserHighestHistory(
              req.params.id
            );
            otherbid = otherbid[0];
            otherbid = otherbid.offer;
            if (bidding.price !== otherbid) {
              data = {
                from: "GPA Team<HCMUS@fit.com>",
                to: bidding.selleremail,
                subject: "Online Auction",
                text: `Hi ${bidding.seller},\nCongratulations!\nYour product ${
                  bidding.name
                } has been offered for ${numeral(otherbid).format(
                  "0,0"
                )}đ.\n\nThank you for joining us!\nHappy selling!\nSent: ${moment()}`,
              };
              mailgun.messages().send(data);
            }
          }
          if (exholder.length == 1) {
            exholder = exholder[0];
            if (exholder.email !== bidding.bidderemail) {
              var userHold = await usermodel.getIDbyEmail(exholder.email);
              userHold = userHold[0];
              if (product.holder !== userHold.id) {
                data = {
                  from: "GPA Team<HCMUS@fit.com>",
                  to: exholder.email,
                  subject: "Online Auction",
                  text: `Hi ${
                    exholder.name
                  },\nUnfortunately!\nSomeone has offered for ${
                    bidding.name
                  } higher than you.\n\nThank you for joining us!\nHappy bidding!\nSent: ${moment()}`,
                };
                mailgun.messages().send(data);
              } else {
                data = {
                  from: "GPA Team<HCMUS@fit.com>",
                  to: exholder.email,
                  subject: "Online Auction",
                  text: `Hi ${exholder.name},\nSomeone has offered for ${
                    bidding.name
                  } higher than you, but you still hold this product.\n\nThank you for joining us!\nHappy bidding!\nSent: ${moment()}`,
                };
                mailgun.messages().send(data);
              }
            }
          }
          req.session.announce = "Done!";
        }
      }
    }
  } else {
    req.session.announce = "Oops! Something went wrong...";
  }

  req.session.save(function () {
    return res.redirect("/detail/" + req.params.id);
  });
});

export default router;
