import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import Logo from "@/components/ui/logo";
import tshirtImage from "@/assets/tshirt.jpg";

const Main = () => {
  return (
    <div className="min-h-screen pulse-bg">
      <header className="p-4 flex items-center justify-between">
        <Logo />
        <div className="flex gap-4">
          <Link to="/login">
            <Button variant="outline" className="glow-effect bg-white/90">
              Login
            </Button>
          </Link>
          <Link to="/register">
            <Button className="glow-effect">
              Sign Up
            </Button>
          </Link>
        </div>
      </header>

      <main className="container mx-auto px-4 py-8">
        <div className="text-center mb-12">
          <h1 className="text-5xl md:text-7xl font-bold text-white mb-6 bounce-in">
            Welcome to AirBear
          </h1>
          <p className="text-xl md:text-2xl text-white/90 mb-8 max-w-3xl mx-auto">
            Ride Green, Snack Smart – AirBear the Eco Way!
          </p>
          <Link to="/book-ride">
            <Button size="lg" className="text-xl px-8 py-4 h-auto glow-effect">
              Book Your Eco Ride
            </Button>
          </Link>
        </div>

        <div className="grid md:grid-cols-2 gap-8 max-w-6xl mx-auto">
          <Card className="bg-white/95 backdrop-blur-sm shadow-xl">
            <CardHeader>
              <CardTitle className="text-2xl text-primary">
                🌱 Solar-Powered Rides
              </CardTitle>
              <CardDescription>
                Clean, sustainable transportation powered by the sun
              </CardDescription>
            </CardHeader>
            <CardContent>
              <p className="text-muted-foreground">
                Our eco-friendly rickshaws are equipped with solar panels, 
                ensuring every ride reduces your carbon footprint while 
                getting you where you need to go.
              </p>
            </CardContent>
          </Card>

          <Card className="bg-white/95 backdrop-blur-sm shadow-xl">
            <CardHeader>
              <CardTitle className="text-2xl text-accent">
                🛒 Onboard Bodegas
              </CardTitle>
              <CardDescription>
                Snacks and drinks available during your journey
              </CardDescription>
            </CardHeader>
            <CardContent>
              <p className="text-muted-foreground">
                Enjoy fresh snacks, cold drinks, and local treats from our 
                carefully curated selection available right in your ride.
              </p>
            </CardContent>
          </Card>
        </div>

        <div className="mt-16 text-center">
          <Card className="bg-gradient-to-br from-secondary to-accent text-white max-w-2xl mx-auto">
            <CardHeader>
              <CardTitle className="text-3xl font-bold bounce-in">
                Special Promo!
              </CardTitle>
              <CardDescription className="text-white/90 text-lg">
                Limited time offer for new riders
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="bg-white/20 rounded-lg p-4">
                <img
                  src={tshirtImage}
                  alt="AirBear Promotional T-Shirt"
                  className="w-full max-w-xs mx-auto rounded-lg shadow-lg"
                />
              </div>
              <div>
                <h3 className="text-4xl font-bold mb-2">$100 T-Shirt Promo</h3>
                <p className="text-lg mb-4">
                  Get this exclusive AirBear eco-friendly t-shirt with your first ride!
                </p>
                <p className="text-sm text-white/80 italic">
                  *Limited to 1 ride per day, purchaser only
                </p>
              </div>
              <Link to="/book-ride">
                <Button size="lg" variant="outline" className="text-xl px-8 py-4 h-auto bg-white text-primary glow-effect">
                  Claim Your Promo
                </Button>
              </Link>
            </CardContent>
          </Card>
        </div>
      </main>
    </div>
  );
};

export default Main;