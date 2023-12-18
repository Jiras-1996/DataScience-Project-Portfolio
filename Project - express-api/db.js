const Database = require("better-sqlite3"); //import better-sqlite3
const db = new Database("book.sqlite"); //create db and set name database file

//create table 
db.exec(
    "CREATE TABLE IF NOT EXISTS books (id INTEGER PRIMARY KEY, title TEXT, year INTEGER)"
); 

module.exports = db; //use module to export db