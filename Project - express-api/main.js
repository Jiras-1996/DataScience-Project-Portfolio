const express = require("express"); // import Express
const db = require("./db.js"); // import db from db.js
const app = express(); //create express app
app.use(express.json()); // express app provide JSON

// create GET method
app.get("/", function(request, response){
    //response.send("<H1>Hello World</H1>")
    response.json({title: "Deep Learning with R", year: 2022})
});

// create POST method
app.post("/books", function(request, response){
    const title = request.body.title;
    const year = request.body.year;
    
    // create SQL statement
    const statement = db.prepare("INSERT INTO books (title, year) VALUES (?, ?)");
    
    const result = statement.run(title, year);

    response.json(result);
});

// create GET method for get POST data
app.get("/books", function(request, response){
    // create SQL statement
    const statement = db.prepare("SELECT * from books");
    const result = statement.all();
    response.json(result);
});

// create GET method to get data from id
app.get("/books/:id", function(request, response){
    const id = request.params.id;
    // create SQL statement
    const statement = db.prepare(`SELECT * from books WHERE id=${id}`);

    const result = statement.get(); // use get() for get data from id
    response.json(result);
});

// create PATCH method
app.patch("/books/:id", function(request, response){
    const id = request.params.id;
    const title = request.body.title;

    // create SQL statement
    const statement = db.prepare("UPDATE books SET title= ? WHERE id = ?");

    const result = statement.run(title, id);
    response.json(result);
});

// create DELETE method
app.delete("/books/:id", function(request, response){
    const id = request.params.id;

    // create SQL statement
    const statement = db.prepare("DELETE from books WHERE id = ?");
    const result = statement.run(id);
    response.json(result);
});

// set API working on port(3000) and function to show Status
app.listen(3000, function(){
    console.log("Application Ready on Port 3000");
});