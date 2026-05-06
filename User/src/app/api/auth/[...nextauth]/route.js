import NextAuth from "next-auth";
import GithubProvider from "next-auth/providers/github";
import GoogleProvider from "next-auth/providers/google";
import CredentialsProvider from "next-auth/providers/credentials";
import conn_to_mon from "@/features/mongoose";
import User from "@/models/User";
import bcrypt from "bcryptjs";

export const authOptions = {
  providers: [
    CredentialsProvider({
      name: "Credentials",
      credentials: {
        email: { label: "Email", type: "text" },
        password: { label: "Password", type: "password" },
      },
      async authorize(credentials) {
        try {
          await conn_to_mon();

          const user = await User.findOne({ email: credentials.email });

          if (!user) {
            throw new Error("No user found with this email");
          }

          const isMatch = await bcrypt.compare(
            credentials.password,
            user.password
          );

          if (!isMatch) {
            throw new Error("Wrong password");
          }

          return {
            id: user._id,
            username: user.username,
            email: user.email,
            phoneNumber: user.phoneNumber,
          };
        } catch (error) {
          console.error("Authorize error:", error);
          throw new Error("Authorization failed");
        }
      },
    }),
    GithubProvider({
      clientId: process.env.GITHUB_CLIENT_ID,
      clientSecret: process.env.GITHUB_CLIENT_SECRET,
    }),
    GoogleProvider({
      clientId: process.env.GOOGLE_CLIENT_ID,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET,
    }),
  ],
  session: {
    jwt: true,
    maxAge: 60 * 60 * 24 * 7, // Token age increased to 7 days
  },
  pages: {
    signIn: "/auth/signin",
  },
  callbacks: {
    async signIn({ user, account }) {
      if (account.provider === "github" || account.provider === "google") {
        await conn_to_mon();
        try {
          const existingUser = await User.findOne({ email: user.email });

          if (!existingUser) {
            const newUser = new User({
              email: user.email,
              username: user.name,
            });
            
            await newUser.save();
          }

          return true; // Continue with sign in
        } catch (error) {
          return false; // Abort sign in
        }
      }

      return true; // Continue sign in for other providers
    },
    async jwt({ token, user }) {
      if (user) {
        token.id = user.id;
        token.username = user.username;
        token.email = user.email;
        token.phoneNumber = user.phoneNumber;
      }
      return token;
    },
    async session({ session, token }) {
      session.user.id = token.id;
      session.user.username = token.username;
      session.user.email = token.email;
      session.user.phoneNumber = token.phoneNumber;
      return session;
    },
  },
  secret: process.env.NEXTAUTH_SECRET,
};

const handler = NextAuth(authOptions);
export { handler as GET, handler as POST };
