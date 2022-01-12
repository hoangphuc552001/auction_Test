import cron from "node-cron";
import productmodel from "../models/productmodel.js";
import crypt from "../utils/crypt.js";
import mailgu from "mailgun-js";
import numeral from "numeral";
import moment from "moment";
import usermodel from "../models/usermodel.js";

const hashedApi = '87188d3dedb0558b49e8baa28b414ee3175caac3e27f94bd73b5fdb0f0651bb206ecb4bfea83a060032bb0ce3fd864db';
const hashedDomain = '7dcecb51f53178edd7a6de01581da0b877ac22c459c6599c460cf8a438e5a2e62858b1e92c828e3d257fc9a16afb4a6aff40479f8e45184330814068' +
    'f12e4764';
const DOMAIN = crypt.decrypt(hashedDomain);
const API = crypt.decrypt(hashedApi);
const mailgun = mailgu({apiKey: API, domain: DOMAIN});
export default async function (app) {
    cron.schedule('* * * * *', async () => {
            var proRenew = await productmodel.getProRenew()
            for (let i = 0; i < proRenew.length; i++) {
                if (proRenew[i].end.getTime() <= new Date().getTime() && proRenew[i].renew===+1) {
                    await productmodel.updateProRenew(proRenew[i].id,new Date(proRenew[i].end.getTime() + 15*60000))
                    await productmodel.updateRenewCondition(proRenew[i].id)
                }
            }
            await productmodel.test();
            let proMailSold = await productmodel.findProductSoldedWithMailing()
            let proMailExpired = await productmodel.findProductExpiredWithMailing()
            for (let i = 0; i < proMailExpired.length; i++) {
                let pro = proMailExpired[i]
                let emailSeller = await usermodel.id(pro.seller)
                let seller = emailSeller[0]
                emailSeller = seller.email
                var entity = {
                    email: emailSeller,
                    productid: pro.id
                }
                var getCheck = await productmodel.getcheckMailWon(entity.email, entity.productid)
                getCheck = getCheck[0]
                if (typeof (getCheck) === 'undefined') {
                    await productmodel.addMailWon(entity)
                }
                getCheck = getCheck.check
                if (getCheck === +0) {
                    var data = {
                        from: 'GPA Team<HCMUS@fit.com>',
                        to: emailSeller,
                        subject: 'Online Auction',
                        text: `Hi ${seller.name},\nSorry!\nYour product: ${pro.name}\nHas been expired!\nThank you for joining us!\nHappy selling!\nSent: ${moment()}`
                    };
                    mailgun.messages().send(data);
                    await productmodel.updateCheckMailWon(entity.email, entity.productid)
                }
            }
            for (let i = 0; i < proMailSold.length; i++) {
                let proSold = proMailSold[i]
                //seller
                let emailSellerSold = await usermodel.id(proSold.seller)
                let sellerSold = emailSellerSold[0]
                emailSellerSold = sellerSold.email
                var entitySeller = {
                    email: emailSellerSold,
                    productid: proSold.id
                }
                var getCheckSeller = await productmodel.getcheckMailWon(entitySeller.email, entitySeller.productid)
                getCheckSeller = getCheckSeller[0]
                if (typeof (getCheckSeller) === 'undefined') {
                    await productmodel.addMailWon(entitySeller)
                }
                getCheckSeller = getCheckSeller.check
                if (getCheckSeller === +0) {
                    var dataSoldSeller = {
                        from: 'GPA Team<HCMUS@fit.com>',
                        to: emailSellerSold,
                        subject: 'Online Auction',
                        text: `Hi ${sellerSold.name},\nCongratulations\nYou've sold successfully: ${proSold.name}\nWith: ${numeral(proSold.current).format("0,0")}đ\nThank you for joining us!\nHappy selling!\nSent: ${moment()}`
                    };
                    mailgun.messages().send(dataSoldSeller);
                    await productmodel.updateCheckMailWon(entitySeller.email, entitySeller.productid)
                }
                //bidder
                let emailBidderSold = await usermodel.id(proSold.holder)
                let bidderSold = emailBidderSold[0]
                emailBidderSold = bidderSold.email
                var entityBidder = {
                    email: emailBidderSold,
                    productid: proSold.id
                }
                var getCheckBidder = await productmodel.getcheckMailWon(entityBidder.email, entityBidder.productid)
                getCheckBidder = getCheckBidder[0]
                if (typeof (getCheckBidder) === 'undefined') {
                    await productmodel.addMailWon(entityBidder)
                }
                getCheckBidder = getCheckBidder.check
                if (getCheckBidder === +0) {
                    var dataSoldBidder = {
                        from: 'GPA Team<HCMUS@fit.com>',
                        to: emailBidderSold,
                        subject: 'Online Auction',
                        text: `Hi ${proSold.info},\nCongratulations\nYou've bid successfully: ${proSold.name}\nWith: $${numeral(proSold.current).format("0,0")}đ\nThank you for joining us!\nHappy bidding!\nSent: ${moment()}`
                    };
                    mailgun.messages().send(dataSoldBidder);
                    await productmodel.updateCheckMailWon(entityBidder.email, entityBidder.productid)
                }

            }
        }
    )
    ;
}
;

