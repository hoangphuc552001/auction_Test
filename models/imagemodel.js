import db from "../utils/db.js";

export default {
    delete(product){
        return db('image').where('product',product).del();
}
}