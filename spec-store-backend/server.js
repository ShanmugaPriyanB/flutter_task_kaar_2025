const express = require('express');
const dotenv = require('dotenv'); dotenv.config();
const cors = require('cors'); 
const app = express();
app.use(cors()); 
app.use(express.json());
const connectDB = require('./config/db');

connectDB();
const productRoutes = require('./routes/productRoutes');
app.use('/api/products', productRoutes);





app.get('/', (req, res) => { res.send('API is running...'); });

const PORT = process.env.PORT || 5000;
 app.listen(PORT, () => { console.log( `Server running on port ${ PORT }`);
 });