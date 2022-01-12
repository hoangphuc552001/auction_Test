import db from '../utils/db.js'

export default {
    async findAllWithDetails() {
        const sql = `select c.*, count(p.id) as ProductCount
                     from category c
                              left join product p on c.id = p.category
                     group by c.id, c.name`
        const raw_data = await db.raw(sql)
        return raw_data[0]
    },
    all (){
        return db('category');
    },
    insert(entity){
        return db('category').insert(entity);
    },
    async getById(id){
        const row = await db('category').where('id',id);
        if(row.length ===null)
            return null;
        return row[0];
    },
    async isParent(catid){
        const row = await db('category').where('parent',catid);

        if(row.length!==0)
            return true;
        return false;
    },
    delete(catid){
        //console.log(catid);
        return db('category').where('id',catid).del();
    },
    update(entity){
        const id = entity.id;
        delete entity.id;
        return db('category').where('id',id).update(entity);
    }
}