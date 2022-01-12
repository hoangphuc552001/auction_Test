export default function validAdmin(req,res,next){
    if(req.session.admin===false){
        req.session.retUrl= req.originalUrl;
        return res.redirect('/login');
    }
    next();
}