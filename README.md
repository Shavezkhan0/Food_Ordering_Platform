# 🍔 Okhla Dastarkhan (Okados) - Comprehensive Food Ordering Ecosystem

![Project Banner](https://img.shields.io/badge/Status-Active_Development-success?style=for-the-badge) 
![Next.js](https://img.shields.io/badge/Next.js-14-black?style=for-the-badge&logo=next.js) 
![MongoDB](https://img.shields.io/badge/MongoDB-Ready-green?style=for-the-badge&logo=mongodb) 
![TailwindCSS](https://img.shields.io/badge/Tailwind_CSS-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white) 
![Redux](https://img.shields.io/badge/Redux-593D88?style=for-the-badge&logo=redux&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-Mobile_App-blue?style=for-the-badge&logo=flutter)

## 🚀 Project Overview

**Okhla Dastarkhan** (brand name: **Okados**) is an enterprise-grade, highly scalable food ordering and delivery ecosystem. The platform acts as a digital bridge between hungry customers, local restaurant owners (shopkeepers), delivery personnel, and platform administrators.

Unlike traditional single-app projects, this ecosystem is built using a **Micro-Frontend/Monorepo Architecture**, separating the logic and routing into dedicated applications that communicate with a centralized MongoDB database.

---

## 🎯 Purpose & Motivation

This project was built from the ground up to showcase advanced proficiency in modern web and mobile development. It demonstrates the ability to:
- Design and architect complex, multi-role systems.
- Securely handle sensitive user data and transactions (Payment Gateways).
- Manage complex global client states (`Redux Toolkit`) alongside server-side rendering (`Next.js`).
- Integrate third-party APIs seamlessly (Cloudinary, Google Maps, NextAuth).
- Build cross-platform mobile apps tied to a centralized web backend.

---

## 🏗️ System Architecture & Modules

The platform is divided into four primary, decoupled applications:

### 1. 🧑‍💻 User Portal (Customer Web App)
The customer-facing application optimized for performance, SEO, and seamless user experience.
* **Intelligent Menu & Search:** Fast product browsing with dynamic filtering by categories.
* **Global State Cart:** Implemented using **Redux Toolkit** and `redux-persist` to maintain cart state across browser sessions.
* **Payment Integration:** Fully functional and secure checkout flow utilizing the **Paytm Payment Gateway** checksum verification API.
* **Location & Geocoding:** Integration with **Google Maps API** for pinpointing delivery addresses and calculating exact distances/delivery fees.
* **Robust Authentication:** Dual authentication strategy using **NextAuth.js** (Email/Password credentials with bcrypt hashing + OAuth social logins).

### 2. 🏪 Shop Keeper Portal (Restaurant Dashboard)
A dedicated management panel for restaurant partners.
* **Dynamic Menu Management:** Shopkeepers can intuitively Add, Read, Update, and Delete (CRUD) food items.
* **Media Management:** Direct, optimized image uploads powered by the **Cloudinary API**.
* **Live Order Tracking:** A real-time dashboard to accept orders and update their lifecycle status (e.g., *Pending -> Preparing -> Ready for Pickup*).
* **Revenue Analytics:** Detailed insights into daily/weekly sales and top-performing dishes.

### 3. 👨‍💼 Admin Portal (Platform Oversight)
The master control center for platform owners.
* **Role-Based Access Control (RBAC):** Strict Next.js middleware protecting admin routes.
* **User & Shopkeeper Oversight:** Complete control over user bans, shopkeeper approvals, and delivery agent assignments.
* **Platform Analytics:** Macro-level visibility into total platform revenue, active users, and system health.

### 4. 📱 Okados Mobile Application (Flutter)
A native cross-platform application for iOS and Android.
* Built using **Flutter (Dart)**.
* Provides a native mobile experience for customers ordering on the go, utilizing the same database and RESTful API endpoints.

---

## 🛠️ Comprehensive Technology Stack

### **Frontend & UI Architecture**
* **Framework:** Next.js 14 (leveraging the App Router and Server-Side Rendering)
* **Library:** React 18
* **Styling:** Tailwind CSS (for highly responsive, utility-first UI design)
* **State Management:** Redux Toolkit & React-Redux
* **Form Handling:** React Hook Form (for performant, re-render-free validations)
* **UI Enhancements:** React Icons, React Toastify (notifications), React Top Loading Bar

### **Backend & Database**
* **Serverless Backend:** Next.js API Routes (acting as the backend controller layer)
* **Database:** MongoDB (NoSQL schema design optimized for fast read/writes)
* **ORM / ODM:** Mongoose (enforcing strict schema validation)
* **Authentication:** NextAuth.js (JWT-based session management)
* **Security:** Bcrypt.js for robust password hashing

### **Third-Party APIs & Services**
* **Payments:** Paytm Gateway API (with secure server-side checksum generation)
* **Storage / CDN:** Cloudinary API (optimized image hosting)
* **Mapping:** Google Maps APIs (Places, Geocoding, Distance Matrix)
* **Communications:** Nodemailer (SMTP transactional emails for order receipts and OTPs)

---

## 📁 Repository Structure

```text
📦 Food_Ordering_Platform
 ┣ 📂 Admin              # Next.js Application (Admin Dashboard)
 ┣ 📂 User               # Next.js Application (Customer Web App)
 ┣ 📂 Shop keeper        # Next.js Application (Restaurant Dashboard)
 ┣ 📂 App Development    # Flutter Application (Mobile App source code)
 ┣ 📂 Delivery           # Delivery routing / logic
 ┗ 📜 README.md
```

---

## 🔐 Security & Best Practices Implemented
- **Route Protection:** Implemented Next.js Middleware to ensure users cannot access Admin or Shopkeeper portals, and vice versa.
- **Data Encryption:** Passwords are never stored in plain text; they are hashed using a high salt round via `bcryptjs`.
- **Stateless Authentication:** Utilizing JSON Web Tokens (JWT) through NextAuth to ensure scalable, stateless sessions.
- **Environment Variable Security:** Sensitive keys (Payment secrets, Database URIs) are kept out of version control and managed via `.env.local`.

---

## ⚙️ Installation & Local Setup Guide

### Prerequisites
* **Node.js:** v18+
* **Package Manager:** `pnpm` (recommended), `npm`, or `yarn`
* **Database:** MongoDB URI
* **API Keys Needed:** Cloudinary, Paytm Merchant Details, Google Maps API

### Running the Ecosystem Locally

1. **Clone the repository**
   ```bash
   git clone https://github.com/Shavezkhan0/Food_Ordering_Platform.git
   cd "Food_Ordering_Platform"
   ```

2. **Configure Environment Variables**
   You must create a `.env.local` file inside **each** Next.js project directory (`/User`, `/Admin`, `/Shop keeper`). Use the following template:
   ```env
   # Database Connection
   MONGOOSE_CONN_STRING=mongodb+srv://<username>:<password>@cluster.mongodb.net/

   # NextAuth Configuration
   NEXTAUTH_SECRET=generate_a_random_secure_string_here
   NEXTAUTH_URL=http://localhost:3000

   # Cloudinary Media Storage
   CLOUDINARY_NAME=your_cloud_name
   CLOUDINARY_KEY=your_api_key
   CLOUDINARY_SECRET=your_api_secret

   # Paytm Gateway Integration
   PAYTM_MID=your_merchant_id
   PAYTM_KEY=your_merchant_key
   PAYTM_HOST=https://securegw.paytm.in

   # Google Maps Location Services
   NEXT_PUBLIC_GOOGLE_MAPS_API_KEY=your_google_maps_api_key
   ```

3. **Install Dependencies & Start Development Servers**
   Because of the Micro-Frontend structure, you run the portals you need on separate terminal tabs.

   **To run the User Portal:**
   ```bash
   cd User
   pnpm install
   pnpm run dev
   ```
   *(The app will start on `http://localhost:3000` or the port specified in your Next.js config)*

   **To run the Admin or Shopkeeper Portals:**
   Repeat the process in their respective directories. *(Tip: Update their `package.json` scripts to run on different ports like `next dev -p 3001` to run them simultaneously).*

---

## 👨‍💻 Developer & Contact

**Developed by Shavez Khan**

I built this project to demonstrate my capability to handle the full software development lifecycle—from backend database design to frontend state management, third-party API integration, and mobile development. 

*If you are reviewing this repository for a job application, please feel free to reach out to me for a live demonstration of the platform's capabilities.*
