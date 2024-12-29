const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const cors = require('cors');
const bcryptjs = require('bcryptjs'); // Correct import for bcryptjs
//onst bcrypt = require('bcrypt'); // For bcrypt

//const bcrypt = require('bcrypt'); // Add bcrypt to handle password hashing

const app = express();
app.use(cors());
app.use(bodyParser.json());

// MySQL connection setup
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '', // Replace with your DB password
  database: 'southern' // Replace with your DB name
});

db.connect(err => {
  if (err) {
    console.error('Database connection failed:', err);
  } else {
    console.log('Database connected.');
  }
});



// Middleware to parse JSON bodies
app.use(bodyParser.json());

// Endpoint to add a new login user with a hashed password
app.post('/add-user', async (req, res) => {
  const { user, password } = req.body;

  if (!user || !password) {
    return res.status(400).json({ message: 'Username and password are required.' });
  }

  // Hash the password using bcrypt
  try {
    const hashedPassword = await bcrypt.hash(password, 10); // 10 is the salt rounds

    // Insert the new user into the login table
    const query = 'INSERT INTO login (user, password) VALUES (?, ?)';
    db.query(query, [user, hashedPassword], (err, result) => {
      if (err) {
        console.error('Error inserting user into database:', err);
        return res.status(500).json({ message: 'Error adding user to the database.' });
      }
      res.status(201).json({ message: 'User added successfully!' });
    });
  } catch (error) {
    console.error('Error hashing password:', error);
    res.status(500).json({ message: 'Error hashing the password.' });
  }
});

// API to get user
app.get('/user', (req, res) => {
  const query = 'SELECT user FROM login'; // Adjust column names based on your DB
  db.query(query, (err, results) => {
    if (err) return res.status(500).send(err);
    res.json(results.map(row => row.user));
  });
});

// API to validate login


app.post('/login', async (req, res) => {
  const { username, password } = req.body;
  // Check if user exists in database
  db.query('SELECT * FROM login WHERE user = ?', [username], async (err, result) => {
    if (err) throw err;

    if (result.length > 0) {
      const user = result[0];
      // Compare password with hashed password in DB
      const isMatch = await bcryptjs.compare(password, user.password);
      if (isMatch) {
        // Success: Generate JWT token (or do whatever you want here)
        res.json({ message: 'Login successful' });
      } else {
        res.status(400).json({ message: 'Invalid password' });
      }
    } else {
      res.status(400).json({ message: 'User not found' });
    }
  });
});

//ADD CUSTOMER

// Route to add customer data
app.post('/addCustomer', (req, res) => {
  const { name, number, email, shopName } = req.body;

  // Validate the received data
  if (!name || !number || !email || !shopName) {
    return res.status(400).json({ error: 'All fields are required' });
  }

  // Insert customer data into MySQL
  const query = 'INSERT INTO customers (name, number, email, shopName) VALUES (?, ?, ?, ?)';
  
  db.query(query, [name, number, email, shopName], (err, result) => {
    if (err) {
      console.error('Error inserting customer data: ' + err.message);
      return res.status(500).json({ error: 'Failed to add customer' });
    }

    // Respond with success
    res.status(200).json({ message: 'Customer added successfully' });
  });
});




// API to get customers
app.get('/customers', (req, res) => {
  const query = 'SELECT name FROM customers';
  db.query(query, (err, results) => {
    if (err) {
      console.error('Error fetching customers:', err);
      return res.status(500).send(err);
    }
    res.json(results.map(row => row.name));
  });
});




// ADD NEW JOB

app.post('/newjob', (req, res) => {
  const { customer, jobname, description, date } = req.body;

  console.log('Received data:', req.body); // Log received data for debugging

  if (!customer || !jobname || !description || !date) {
    console.error('Missing required fields');
    return res.status(400).json({ error: 'All fields are required' });
  }

  const sql = 'INSERT INTO newjob (customer, jobname, description, date) VALUES (?, ?, ?, ?)';
  db.query(sql, [customer, jobname, description, date], (err, result) => {
    if (err) {
      console.error('Error inserting new job:', err); // Log SQL error
      return res.status(500).json({ error: 'Failed to add new job' });
    }
    console.log('Job added successfully:', result);
    res.status(200).json({ message: 'Job added successfully!' });
  });
});



// Fetch all jobs
// Fetch all jobs with the id field
app.get('/newjobsshow', (req, res) => {
  const sql = 'SELECT id, customer, jobname, description, date, process FROM newjob'; // Ensure `id` is selected
  db.query(sql, (err, results) => {
    if (err) {
      console.error('Error fetching jobs:', err);
      return res.status(500).json({ error: 'Failed to fetch jobs' });
    }
    res.status(200).json(results);
  });
});


// Update job process
// Update job details and process
app.put('/updatejob/:id', (req, res) => {
  const jobId = req.params.id;
  const { jobname, description, process } = req.body;

  if (!jobname || !description || !process) {
    return res.status(400).json({ error: 'All fields (jobname, description, process) are required' });
  }

  const sql = 'UPDATE newjob SET jobname = ?, description = ?, process = ? WHERE id = ?';
  db.query(sql, [jobname, description, process, jobId], (err, result) => {
    if (err) {
      console.error('Error updating job:', err);
      return res.status(500).json({ error: 'Failed to update job' });
    }
    res.status(200).json({ message: 'Job updated successfully' });
  });
});









// Add daily work
app.post('/add-dailywork', (req, res) => {
  const { customer_name, job_name, paper_description, binding_amount, no_of_impressions, impression_amount, paper_amount, total_amount, payment, balance, date } = req.body;

  const query = `
    INSERT INTO dailyworks (
      customer_name, job_name, paper_description, binding_amount, 
      no_of_impressions, impression_amount, paper_amount, 
      total_amount, payment, balance, date
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `;

  db.query(query, [customer_name, job_name, paper_description, binding_amount, no_of_impressions, impression_amount, paper_amount, total_amount, payment, balance, date], (err, result) => {
    if (err) {
      console.error('Failed to insert data:', err);
      res.status(500).send('Failed to add data.');
    } else {
      res.status(200).send({ message: 'Data added successfully', id: result.insertId });
    }
  });
});

// Fetch daily work summary for a specific date
app.post('/getDailyWorks', (req, res) => {
  const { selectedDate } = req.body; // Expecting date in 'YYYY-MM-DD' format

  const query = `
    SELECT 
      SUM(impression_amount) as total_impression_amount, 
      SUM(payment) as total_payment, 
      SUM(no_of_impressions) as total_impression
    FROM 
      dailyworks 
    WHERE 
      DATE(date) = ?;
  `;

  db.query(query, [selectedDate], (err, results) => {
    if (err) return res.status(500).send(err);

    res.json({
      total_impression_amount: results[0].total_impression_amount || 0,
      total_payment: results[0].total_payment || 0,
      total_impression: results[0].total_impression || 0,
    });
  });
});



// API to update a specific job in the dailyworks table
// API to update a specific job in the dailyworks table
app.put('/update-job', (req, res) => {
  const {
    customer_name,
    job_name,
    paper_description,
    binding_amount,
    no_of_impressions,
    impression_amount,
    paper_amount,
    total_amount,
    payment,
    balance,
    date
  } = req.body;

  const query = `
    UPDATE dailyworks 
    SET 
      paper_description = ?, 
      binding_amount = ?, 
      no_of_impressions = ?, 
      impression_amount = ?, 
      paper_amount = ?, 
      total_amount = ?, 
      payment = ?, 
      balance = ?, 
      date = ? 
    WHERE customer_name = ? AND job_name = ?
  `;

  db.query(
    query,
    [
      paper_description,
      binding_amount,
      no_of_impressions,
      impression_amount,
      paper_amount,
      total_amount,
      payment,
      balance,
      date,
      customer_name,
      job_name
    ],
    (err, result) => {
      if (err) {
        console.error('Error updating record:', err);
        return res.status(500).json({ error: 'Failed to update record' });
      }
      res.status(200).json({ message: 'Job details updated successfully', affectedRows: result.affectedRows });
    }
  );
});



// API endpoint to fetch daily works for a specific date
app.get('/dailyworks/:date', (req, res) => {
  const selectedDate = req.params.date;
  console.log(`Fetching daily works for date: ${selectedDate}`);

  const query = `
    SELECT customer_name, job_name, paper_description, no_of_impressions, total_amount, impression_amount, payment 
    FROM dailyworks 
    WHERE date = ?`;

  db.query(query, [selectedDate], (err, results) => {
    if (err) {
      console.error('Database error:', err);
      res.status(500).send('Error fetching daily works');
    } else {
      console.log('Results:', results);
      res.json(results);
    }
  });
});


// Fetch daily work details for a specific date
app.post("/getDailyWorks", (req, res) => {
  const { selectedDate } = req.body;
  if (!selectedDate) {
    return res.status(400).send({ error: "Selected date is required." });
  }

  const query = `
    SELECT customer_name, job_name, paper_description, binding_amount,
           no_of_impressions, impression_amount, paper_amount, total_amount,
           payment, balance, date
    FROM dailyworks
    WHERE date = ?
  `;

  db.query(query, [selectedDate], (err, results) => {
    if (err) {
      console.error("Error fetching daily works: ", err);
      res.status(500).send({ error: "Database query failed." });
      return;
    }

    res.status(200).send({ dailyWorks: results });
  });
});

// Apply payment to jobs in descending order
// Apply payment to jobs in descending order
app.post('/apply-payment', async (req, res) => {
  const { customerName, paymentAmount } = req.body;

  if (!customerName || !paymentAmount) {
    return res.status(400).send({ error: "Customer name and payment amount are required." });
  }

  try {
    let remainingPayment = paymentAmount;

    // Query to get jobs for the customer with balance > 0, ordered by date ascending
    db.query(
      `SELECT * FROM dailyworks 
       WHERE customer_name = ? AND balance > 0 
       ORDER BY date ASC`,  // Sorting by date in ascending order (past jobs first)
      [customerName],
      (err, result) => {
        if (err) {
          console.error("Error in query:", err);
          return res.status(500).send({ error: "Database query failed." });
        }

        // Access the results (an array of jobs)
        const jobs = result;

        // Ensure jobs is iterable (an array)
        if (!Array.isArray(jobs) || jobs.length === 0) {
          return res.status(404).send({ error: "No jobs found for this customer with a balance greater than zero." });
        }

        // Iterate over the jobs and apply payment
        for (const job of jobs) {
          if (remainingPayment <= 0) break; // Stop if all payment has been applied

          const paymentToApply = Math.min(job.balance, remainingPayment);
          remainingPayment -= paymentToApply;

          // Update the job payment and balance in the database
          db.query(
            `UPDATE dailyworks 
             SET payment = payment + ?, balance = balance - ? 
             WHERE job_name = ? AND customer_name = ?
             ORDER BY date ASC
             
             `,
            [paymentToApply, paymentToApply, job.job_name, customerName],
            (updateErr) => {
              if (updateErr) {
                console.error("Error updating job:", updateErr);
                return res.status(500).send({ error: "Failed to update job with payment." });
              }
            }
          );
        }

        // Return the result of applying the payment
        res.json({ remainingPayment, message: 'Payment applied successfully' });
      }
    );
  } catch (error) {
    console.error('Error in applying payment:', error);
    res.status(500).send({ error: 'Database error occurred while applying payment' });
  }
});


/// Node.js: /customer-summary endpoint
app.post('/customer-summary', (req, res) => {
  const { customerName } = req.body;

  const summaryQuery = `
    SELECT 
      SUM(total_amount) AS total_amount, 
      MAX(payment) AS last_payment, 
      (SUM(total_amount) - SUM(payment)) AS balance 
    FROM dailyworks 
    WHERE customer_name = ?
  `;

  const historyQuery = `
    SELECT 
      *
    FROM dailyworks 
    WHERE customer_name = ?
    ORDER BY date DESC
  `;

  db.query(summaryQuery, [customerName], (err, summaryResults) => {
    if (err) {
      console.error('Database error in summary query:', err);
      return res.status(500).send('Error fetching customer summary');
    }

    db.query(historyQuery, [customerName], (err, historyResults) => {
      if (err) {
        console.error('Database error in history query:', err);
        return res.status(500).send('Error fetching customer history');
      }

      res.json({
        summary: summaryResults[0], // Aggregate totals
        history: historyResults,   // List of jobs
      });
    });
  });
});


// Daily Income 
app.post('/getDailyIncome', async (req, res) => {
  const { selectedDate } = req.body; // Expecting the date in 'YYYY-MM-DD' format
  try {
    const [results] = await db.execute(
      `SELECT SUM(payment_amount) AS total_income FROM payment_history WHERE payment_date = ?`,
      [selectedDate]
    );
    res.status(200).json(results[0]); // Return the total income
  } catch (error) {
    console.error('Error fetching daily income:', error);
    res.status(500).send('Error fetching daily income');
  }
});






// Insert payment into payment_history
app.post('/add-payment', (req, res) => {
  const { customerName, paymentAmount, paymentDate } = req.body;
  const query = `INSERT INTO payment_history (customer_name, payment_amount, payment_date) VALUES (?, ?, ?)`;
  db.query(query, [customerName, paymentAmount, paymentDate], (err) => {
    if (err) {
      console.error('Failed to insert payment:', err);
      res.status(500).send('Failed to add payment');
      return;
    }
    res.status(200).send('Payment added successfully');
  });
});

// Fetch payment history
app.get('/payment-history', (req, res) => {
  const { customerName } = req.query;

  let query = 'SELECT * FROM payment_history';
  const params = [];

  if (customerName) {
    query += ' WHERE customer_name = ? ORDER BY payment_date DESC';
    params.push(customerName);
  } else {
    query += ' ORDER BY payment_date DESC';
  }

  db.query(query, params, (err, results) => {
    if (err) {
      console.error('Failed to fetch payment history:', err);
      res.status(500).send('Failed to fetch payment history');
      return;
    }

    // Convert payment_date to local timezone
    const updatedResults = results.map((row) => {
      const localDate = new Date(row.payment_date).toLocaleDateString('en-CA'); // Format: YYYY-MM-DD
      return { ...row, payment_date: localDate };
    });

    res.status(200).json(updatedResults);
  });
});






// Endpoint to add shop details
app.post('/add-shop', (req, res) => {
  const { shopName, whatsappNumber, emailAddress } = req.body;

  if (!shopName || !whatsappNumber || !emailAddress) {
    return res.status(400).json({ error: 'All fields are required.' });
  }

  const query = `INSERT INTO shop (shop_name, whatsapp_number, email_address) VALUES (?, ?, ?)`;

  db.query(query, [shopName, whatsappNumber, emailAddress], (err, result) => {
    if (err) {
      console.error('Error inserting shop data:', err);
      return res.status(500).json({ error: 'Database insertion failed.' });
    }
    res.status(200).json({ message: 'Shop added successfully.', shopId: result.insertId });
  });
});




// Node.js API to fetch shop names
app.get('/getShopNames', (req, res) => {
  const query = 'SELECT shop_name FROM shop';

  db.query(query, (err, results) => {
    if (err) {
      console.error('Error fetching shop names:', err);
      res.status(500).send('Error fetching shop names');
    } else {
      res.status(200).json(results);
    }
  });
});




// API to insert paper details
app.post('/addPaperDetails', (req, res) => {
  const { shopName, amount, payment, description, date } = req.body;
  const balance = amount - payment;

  const query = `
    INSERT INTO paperdetails (shop_name, amount, payment, balance, description, date)
    VALUES (?, ?, ?, ?, ?, ?)
  `;

  db.query(query, [shopName, amount, payment, balance, description, date], (err, results) => {
    if (err) {
      console.error('Error inserting data:', err);
      res.status(500).send('Error inserting data');
    } else {
      res.status(200).send('Data inserted successfully');
    }
  });
});


// Fetch all paper details
app.get('/paperdetails', (req, res) => {
  const query = 'SELECT id, shop_name, amount, payment, balance, description, DATE_FORMAT(date, "%Y-%m-%d") AS date FROM paperdetails';
  db.query(query, (err, results) => {
    if (err) {
      console.error('Error fetching paper details:', err);
      res.status(500).send('Internal Server Error');
    } else {
      res.json(results);
    }
  });
});




// Payment Update pepar details


app.post('/updatePaymentpaper', (req, res) => {
  const { id, additionalPayment } = req.body;

  const updateQuery = `
    UPDATE paperdetails
    SET 
      payment = payment + ?,
      balance = amount - (payment + ?)
    WHERE id = ?
  `;

  db.query(updateQuery, [additionalPayment, additionalPayment, id], (err, result) => {
    if (err) {
      console.error('Error updating payment:', err);
      res.status(500).send('Internal Server Error');
    } else {
      res.send({ message: 'Payment updated successfully' });
    }
  });
});




// Start the server
app.listen(3000, () => {
  console.log('Server running on http://localhost:3000');
});
