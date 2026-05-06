import { Inter } from "next/font/google";
import "./globals.css";
import Footer from "@/components/Footer";
import Navbar from "@/components/Navbar";
import { ReduxProvider } from "@/redux/ReduxProvider";
import AuthProvider from "@/features/AuthProvider";
// import { authOptions } from "./api/auth/[...nextauth]/route";
import { authOptions } from "@/lib/auth";
import { getServerSession } from "next-auth";
import NavbarBottom from "@/components/NavbarBottom";

const inter = Inter({ subsets: ["latin"] });

export const metadata = {
  title: "Okhla Dastarkhan : Order Food from Your Favorite Restaurants",
  description:
    "Craving the flavors of Okhla? Order your favorite food from top-rated local restaurants with Okhla Dastarkhan. Enjoy fast delivery and convenient online ordering.",
  keywords:
    "okhla dastarkhan  ,Okhla Dastarkhan  ,okhla dastarkhwan ,Okhla Dastarkhwan ,  Okhla restaurants,Okhla food delivery, food delivery app, online food ordering, Okhla Dastarkhan",
  // Add more keywords as relevant, such as specific cuisines or restaurant types
  author: "Okhla Dastarkhan", // Replace with your website's name
  image: "https://okhladastarkhan.in/logo.png", // Replace with the URL of your website's logo
  url: "https://okhladastarkhan.in", // Add the URL of your website
  canonical: "https://okhladastarkhan.in", // Canonical URL for SEO
};

export default async function RootLayout({ children }) {
  const session = await getServerSession();

  return (
    <html lang="en">
      <head>
        <title>{metadata.title}</title>
        <meta name="description" content={metadata.description} />
        <meta name="keywords" content={metadata.keywords} />
        <meta name="author" content={metadata.author} />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />

        {/* Canonical URL */}
        <link rel="canonical" href={metadata.canonical} />

        {/* Open Graph Meta Tags */}
        <meta property="og:title" content={metadata.title} />
        <meta property="og:description" content={metadata.description} />
        <meta property="og:image" content={metadata.image} />
        <meta property="og:url" content={metadata.url} />
        <meta property="og:type" content="website" />

        {/* Twitter Card Meta Tags */}
        <meta name="twitter:card" content="summary_large_image" />
        <meta name="twitter:title" content={metadata.title} />
        <meta name="twitter:description" content={metadata.description} />
        <meta name="twitter:image" content={metadata.image} />
      </head>

      <body className={inter.className}>
        <AuthProvider session={session}>
          <ReduxProvider>
            <Navbar />
            <NavbarBottom/>
            {children}
            <Footer />
          </ReduxProvider>
        </AuthProvider>
      </body>
    </html>
  );
}
