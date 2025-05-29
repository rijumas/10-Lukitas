 const mongoose = require('mongoose');

 const connection = mongoose.createConnection('mongodb://localhost:27017/newToDo').on('open',()=>{
    console.log("MongoDB Conectado");
 }).on('error',()=>{
    console.log("MongoDB Conectado ERROR");
 })

 module.exports = connection;