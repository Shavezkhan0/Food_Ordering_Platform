// src/pages/api/hello.js

export default function handler(req, res) {
  const pincode = {
    110025: { city: "South Delhi", state: "New Delhi", country: "India" },
    110065: { city: "South Delhi", state: "New Delhi", country: "India" },
    
  };

  res.status(200).json(pincode);
}
