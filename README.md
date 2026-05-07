# 🍔 Okhla Dastarkhan - Full Stack Food Ordering & Delivery Platform

![Project Banner](https://img.shields.io/badge/Status-Active_Development-success?style=for-the-badge) ![Next.js](https://img.shields.io/badge/Next.js-14-black?style=for-the-badge&logo=next.js) ![MongoDB](https://img.shields.io/badge/MongoDB-Ready-green?style=for-the-badge&logo=mongodb) ![Flutter](https://img.shields.io/badge/Flutter-Mobile_App-blue?style=for-the-badge&logo=flutter)

## 🚀 Overview

**Okhla Dastarkhan** (also known as Okados) is a comprehensive, enterprise-grade food ordering and delivery ecosystem. The platform bridges the gap between hungry customers, local restaurant owners (shopkeepers), delivery personnel, and platform administrators through a suite of specialized, decoupled applications running on a unified backend infrastructure.

This project was built to demonstrate proficiency in **full-stack web development**, **micro-frontend architecture**, **secure payment integrations**, and **cross-platform mobile app development**.

---

## 🏗️ Architecture & Modules

The platform is structured into distinct modules, each tailored for a specific user role:

### 1. 🧑‍💻 User Portal (Customer Web App)
The primary storefront where customers interact with the platform.
* **Smart Menu Browsing:** Browse restaurants, categories, and dynamic product listings.
* **Cart & State Management:** Robust client-side cart implementation using **Redux Toolkit** and `redux-persist`.
* **Secure Checkout:** Fully integrated with the **Paytm Payment Gateway** for secure transactions.
* **Location Services:** **Google Maps API** integration for accurate delivery address tracking and distance calculation.
* **Authentication:** Secure login/signup using **NextAuth.js** (supports Credentials and OAuth).

### 2. 🏪 Shop Keeper Portal (Restaurant Management)
A dedicated dashboard for restaurant partners.
* **Menu Management:** Add, edit, and categorize food items.
* **Media Uploads:** Seamless food image uploads powered by **Cloudinary**.
* **Order Management:** Real-time visibility into incoming orders with the ability to update preparation status.
* **Analytics:** Track daily orders, revenue, and customer feedback.

### 3. 👨‍💼 Admin Portal (Platform Oversight)
The master control panel for platform operators.
* **User Management:** Oversee all customers, shopkeepers, and delivery agents.
* **Global Analytics:** Track platform-wide sales, active orders, and revenue metrics.
* **Verification & Support:** Approve new restaurant listings and handle platform disputes.

### 4. 📱 Mobile Application (Flutter)
A cross-platform mobile application (`Okados`) built with Flutter, providing on-the-go access to the platform's core services.

---

## 🛠️ Technology Stack

This platform leverages a modern, highly scalable technology stack:

### **Frontend (Web)**
* **Framework:** Next.js 14 (React 18)
* **Styling:** Tailwind CSS
* **State Management:** Redux Toolkit
* **Forms & Validation:** React Hook Form
* **UI Components:** React Icons, React Toastify, React Top Loading Bar

### **Backend & Database**
* **API Layer:** Next.js API Routes (Serverless Functions)
* **Database:** MongoDB
* **ORM:** Mongoose
* **Authentication:** NextAuth.js (JWT-based sessions)
* **Security:** Bcrypt.js (Password Hashing)

### **Third-Party Integrations**
* **Payments:** Paytm Checksum & API
* **Storage:** Cloudinary API
* **Location:** Google Maps API
* **Emails:** Nodemailer (Transactional Emails)

### **Mobile (App Development)**
* **Framework:** Flutter (Dart)

---

## ⚙️ Getting Started (Local Development)

### Prerequisites
* Node.js (v18+)
* pnpm (recommended) or npm
* MongoDB instance (Local or Atlas)
* API Keys for Cloudinary, Paytm, and Google Maps

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/Shavezkhan0/Food_Ordering_Platform.git
   cd "Food_Ordering_Platform"
   ```

2. **Environment Variables**
   Create a `.env.local` file in the root of the `User`, `Admin`, and `Shop keeper` directories with the following structure:
   ```env
   # Database
   MONGOOSE_CONN_STRING=mongodb+srv://<username>:<password>@cluster.mongodb.net/

   # Authentication
   NEXTAUTH_SECRET=your_super_secret_key
   NEXTAUTH_URL=http://localhost:3000

   # Cloudinary
   CLOUDINARY_NAME=your_cloud_name
   CLOUDINARY_KEY=your_api_key
   CLOUDINARY_SECRET=your_api_secret

   # Paytm
   PAYTM_MID=your_merchant_id
   PAYTM_KEY=your_merchant_key
   PAYTM_HOST=https://securegw.paytm.in

   # Google Maps
   NEXT_PUBLIC_GOOGLE_MAPS_API_KEY=your_google_maps_api_key
   ```

3. **Install Dependencies & Run**
   Because the project is separated into different portals, you need to run them individually. For example, to run the User portal:
   
   ```bash
   cd User
   pnpm install
   pnpm run dev
   ```
   *Repeat this for the `Admin` and `Shop keeper` directories as needed (make sure they run on different ports by updating the `package.json` scripts).*

---

## 👨‍💻 Developer / Contact

Developed by **Shavez Khan**.
This project was built to showcase expertise in full-stack JavaScript development, system design, and API integrations for modern web applications. 
