
import express from "express";
const router = express.Router();
import usermodel from "../models/usermodel.js";
import bcrypt from 'bcryptjs';
import mailgu from "mailgun-js/lib/mailgun.js" ;
import crypt from "../utils/crypt.js";
import admin from "../middlewares/admin.mdw.js";
import moment from "moment";


import {render} from "node-sass";




const hashedApi = 'cfa353fd7c66209ea421632da65c2fff76ee775ad015a142085ef8f1e49d5156bfa8ffca0492dfa705f8fa2dd393f7b5cba39f805a69edbbdce8a56bf8a015c4';
const hashedDomain = '8725d7c91e2849bb63f5a44e2558a9f87d88aba6044e8e3a98ecfc14ea3181a5c7931b4104e02cebdff1aa653c6efcc0af4044c9e8e6926c671f3afd922ce0ab';
const DOMAIN = crypt.decrypt(hashedDomain);
const API = crypt.decrypt(hashedApi);
const mailgun = mailgu({apiKey: API, domain: DOMAIN});

router.get('/', async function (req, res) {
    // await productmodel.refresh();
    // var end = await productmodel.end();
    // var price = await productmodel.price();
    // var bids = await productmodel.bids();

    req.session.save(function () {
        return res.render('./', {
            end: end,
            price: price,
            bids: bids,
        });
    });
});
router.get('/about', async function (req, res) {

    res.render("about-us", {
    });
});
router.get('/contact', async function (req, res) {

    res.render("contact-us", {
    });
});
router.get('/login', async function (req, res) {
  //  if (req.headers.referer.indexOf("/login") == -1 && req.headers.referer.indexOf("/registers") == -1 && req.headers.referer.indexOf('/otp') == -1)
   //     req.session.previous = req.headers.referer;

    if (req.headers.referer) {
        if (req.headers.referer.indexOf("/login") == -1 && req.headers.referer.indexOf("/registers") == -1 && req.headers.referer.indexOf('/otp') == -1)
            req.session.previous = req.headers.referer;
    }
    var announce = req.session.announce;
    delete req.session.announce;
    req.session.save(function () {
        return res.render('./login', {
            announce: announce
        });
    });
});

router.post('/login', async function (req, res) {
    var user = await usermodel.check(req.body.email);
    user = user[0];
    if (typeof(user) === 'undefined')
        return res.render('./login', {
            announce: 'Invalid username or password.'
        });

    const rs = bcrypt.compareSync(req.body.password, user.password);
    if (rs === false)
        return res.render('./login', {
            announce: 'Invalid username or password.'
        });
    req.session.authenticated=false;
    delete user.password;
    req.session.user = user;
    const otp = Math.floor(100000 + Math.random() * 900000);
    const entity = {
        otp: otp,
        email: user.email
    }

    await usermodel.otp(entity)

    const data = {
        from: 'GPA Team <HCMUS@fit.com>',
        to: req.session.user.email,
        subject: 'Online Auction',
        text: `Here is your one-time-passcode\n${otp}\nTo complete your process, enter the code in the web page when you requested it.\nNOTE: This one-time-passcode expires 15 minutes after it was requested.`
    };

    mailgun.messages().send(data);

    req.session.save(function () {
        return res.redirect('/otp');
    });
});



router.get('/logout', async function (req, res) {
    req.session.authenticated = false;
    req.session.admin=false;
    req.session.user = null;
  // if (req.headers.referer){
  //    //if(typeof (req.headers.referer)==='undefined')
  //    //     req.headers.referer='/';
  //     if (req.headers.referer.indexOf("account") != -1)
  //         return req.session.save(function () {
  //             return res.redirect('/');
  //         });

  // }
    return res.redirect(req.headers.referer)||'/';

    // req.session.save(function () {
    //     return res.redirect(req.headers.referer)||'/';
    // });
});

router.post('/validateemail', async function (req, res) {
    var user = await usermodel.check(req.body.resetEmail);
    user = user[0];
    if (typeof(user) === 'undefined')
        return res.render('./login', {
            announce: "Email isn't registered."
        });

    req.session.previous = '/reset';
    delete user.password;
    req.session.authenticated = false;
    req.session.user = user;
    const otp = Math.floor(100000 + Math.random() * 900000);
    const entity = {
        otp: otp,
        email: user.email
    }

    await usermodel.otp(entity)

    const data = {
        from: 'GPA Team <HCMUS@fit.com>',
        to: req.session.user.email,
        subject: 'Online Auction',
        text: `Here is your one-time-passcode\n${otp}\nTo complete your process, enter the code in the web page when you requested it.\nNOTE: This one-time-passcode expires 15 minutes after it was requested.`
    };

    mailgun.messages().send(data);

    req.session.save(function () {
        return res.redirect('/otp');
    });
})

router.get('/reset', async function (req, res) {
    req.session.previous = '/';
    res.render('./reset');
})

router.post('/reset', async function (req, res) {
    const salt = bcrypt.genSaltSync(10);
    const hash = bcrypt.hashSync(req.body.password, salt);
    const entity = {
        password: hash
    }
    const condition = {
        id: req.session.user.id
    }

    await usermodel.update(entity, condition);
    const data = {
        from: 'GPA <HCMUS@fit.com>',
        to: req.session.user.email,
        subject: 'Online Auction',
        text: `Hi,\nYour password has been changed successfully!\nThank you for joining GPA Online Auction\nSent: ${moment()}`
    };

    mailgun.messages().send(data);
    req.session.announce = "Your password has been changed successfully!"


    req.session.save(function () {
        return res.redirect('/login');
    });
})

router.get('/register', async function (req, res) {
    res.render('./register');
});

router.post('/register', async function (req, res) {
    var checking = await usermodel.check(req.body.register_email);
    if (checking.length == 0) {
        const salt = bcrypt.genSaltSync(10);
        const hash = bcrypt.hashSync(req.body.register_password, salt);
        const dob=moment(req.body.register_birthday,'DD/MM/YYYY').format('YYYY-MM-DD')
        const entity = {
            name: req.body.register_name,
            email: req.body.register_email,
            password: hash,
            address: req.body.register_address,
            birthday:dob
        }
        await usermodel.add(entity);
        var user = await usermodel.check(entity.email);
        user = user[0];
        const data = {
            from: 'GPA Team<HCMUS@fit.com>',
            to: user.email,
            subject: 'Online Auction',
            text: `Hi,\nThanks for joining GPA Online Auction! Please confirm your email address by clicking on the link below. We'll communicate with you from time to time via email so it's important that we have an up-to-date email address on file.\nhttps://online-auction-db.herokuapp.com/active/${user.id}\nIf you did not sign up for a GPA account please disregard this email.\nHappy emailing!\nAdministrators`
        };

        mailgun.messages().send(data);

        // res.render('./login', {
        //     announce: "Signup complete! We've sent you a mail to confirm, please follow the link inside to active your account."
        // });
        res.render('./confirmmail')
    } else {
        res.render("./register", {
            name: req.body.register_name,
            email: req.body.register_email,
            password: req.body.register_password,
            repeat: req.body.register_repeat,
            address: req.body.register_address,
            birthday:req.body.register_birthday,
            error: "This email address is already being used!"
        });
    }
})

router.get('/404', async function (req, res) {
    res.render('./404');
});

router.get('/otp', async function (req, res) {
 //   if(typeof (req.headers.referer.indexOf("/login"))==="undefined"||typeof (req.headers.referer.indexOf("/registers"))==="undefined"){
 //       req.session.previous = req.headers.referer;
 //       res.redirect('/login')
 //   }
    if (req.headers.referer.indexOf("/login") === -1 && req.headers.referer.indexOf("/registers") === -1 && req.headers.referer.indexOf('/otp') === -1)
        req.session.previous = req.headers.referer;
    res.render('./otp');
});

router.post('/otp',async function (req, res) {
    let otp = req.body.otp;

    var target = await usermodel.verify(req.session.user.email)
    target=target[0];


    if (target.length === 0) {
        return res.render('./otp', {
            announce: 'Something went wrong, please re-login!'
        })
    }


    if (moment().isBefore(target.end)) {
        if (otp === target.otp) {
   //        if (req.session.previous.localeCompare("/reset") != 0) {
                req.session.authenticated = true;
    //       }

            //req.session.authenticated = true;
            const url = req.session.previous;
            delete req.session.previous;
            if (req.session.user.privilege == null)
                return req.session.save(function () {
                        return res.redirect('/account/reminder');
                });

            else if (req.session.user.privilege === "admin"){
                req.session.admin=true;
                return req.session.save(function () {
                    const retUrl = req.session.retUrl||'/account/admin';
                    return res.redirect(retUrl);
                });
            }

            else if (url)
                return req.session.save(function () {
                    return res.redirect(url);
                });
            else
                return req.session.save(function () {
                    return res.redirect('./');
                });
        } else {
            return res.render('./otp', {
                announce: 'Invalid OTP!'
            })
        }
    }

    otp = Math.floor(100000 + Math.random() * 900000);
    const entity = {
        otp: otp,
        email: req.session.user.email
    }

    await usermodel.otp(entity)

    const data = {
        from: 'GPA Team<HCMUS@fit.com>',
        to: req.session.user.email,
        subject: 'Online Auction',
        text: `Here is your one-time-passcode\n${otp}\nTo complete your process, enter the code in the web page when you requested it.\nNOTE: This one-time-passcode expires 15 minutes after it was requested.`
    };

    mailgun.messages().send(data);

    res.render('./otp', {
        announce: 'OTP expires. We have sent new one to your email!'
    });


    router.get('/reset', async function (req, res) {
        req.session.previous = '/';
        res.render('./reset');
    })
});




router.post('/profile/:name/edit-name', (req, res, next) => {
    usermodel.singleByUserName(req.body.newusername)
        .then(user => {
            if (user) {
                alert("Username exist!");
                return res.redirect('/user/profile/' + req.session.user.name);
            } else {
                usermodel
                    .updateName({
                        name: req.body.newusername
                    }, {
                        where: { name: req.session.user.name }
                    })
                    .then(function() {
                        usermodel
                            .singleByUserName(req.body.newusername)
                            .then(user => {
                                req.session.user = user;
                                res.locals.user = req.session.user;
                                res.redirect('/');
                            })
                            .catch(error => next(error));
                    })
                    .catch(function(error) {
                        res.json(error);
                        console.log("update profile failed!");
                    });
            }
        })
});

router.post('/profile/:name/edit-email', (req, res, next) => {
    usermodel.singleByEmail(req.body.newemail)
        .then(user => {
            if (user) {
                alert("Email exist!");
                return res.redirect('/user/profile/' + req.session.user.name);
            } else {
                usermodel
                    .update({
                        email: req.body.newemail
                    }, {
                        where: { name: req.session.user.email }
                    })
                    .then(function() {
                        usermodel
                            .singleByEmail(req.body.newemail)
                            .then(user => {
                                req.session.user = user;
                                res.locals.user = req.session.user;
                                res.redirect('/');
                            })
                            .catch(error => next(error));
                    })
                    .catch(function(error) {
                        res.json(error);
                        console.log("update profile failed!");
                    });
            }
        })
});

router.post('/profile/:name/edit-dob', (req, res, next) => {
    usermodel.singleByUserName(req.params.name)
        .then(function() {
            const salt = bcrypt.genSaltSync(10);
            const hash = bcrypt.hashSync(req.body.newdob, salt);
            usermodel
                .updatePassword({
                    dob: hash
                }, {
                    where: { name: req.session.user.name }
                })
                .then(function() {
                    usermodel
                        .singleByUserName(req.params.name)
                        .then(user => {
                            req.session.user = user;
                            res.locals.user = req.session.user;
                            res.redirect('/');
                        })
                        .catch(error => next(error));
                })
                .catch(function(error) {
                    res.json(error);
                    console.log("update profile failed!");
                });
        })
});

export default router;

