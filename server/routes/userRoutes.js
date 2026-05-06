import express from 'express';
import { allUser, userExist, userLogin, userOtpVerify, userRegister, userSetPassword, userUpdateAddress, userUpdateNamePhone, userUpdatePassword } from '../controller/userControllers.js';

// Initialize the router
const userRoutes = express.Router();

// Define user-related routes here
userRoutes.get('/', (req, res) => {
  res.send('Users Api');
});

userRoutes.get('/allUser', allUser);
userRoutes.post('/login', userLogin);
userRoutes.post('/register', userRegister);
userRoutes.post('/exist', userExist);
userRoutes.post('/otpVerify', userOtpVerify);
userRoutes.post('/setPassword', userSetPassword);
userRoutes.post('/userUpdateNamePhone', userUpdateNamePhone);
userRoutes.post('/userUpdateAddress', userUpdateAddress);
userRoutes.post('/userUpdatePassword', userUpdatePassword);

userRoutes.get('/profile', (req, res) => {
  res.json({ message: 'This is the user profile route' });
});

// Export the router
export default userRoutes;
