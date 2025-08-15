import { useState } from "react";
import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { ArrowLeft, MapPin } from "lucide-react";
import Logo from "@/components/ui/logo";

const BookRide = () => {
  const [startLocation, setStartLocation] = useState("");
  const [endLocation, setEndLocation] = useState("");

  const locations = [
    "Downtown Plaza",
    "University Campus",
    "Shopping District",
    "Riverside Park",
    "Business Center",
    "Airport Terminal",
    "Train Station",
    "Beach Boardwalk"
  ];

  const handleBooking = () => {
    // TODO: Implement booking logic
    console.log("Booking ride:", { startLocation, endLocation });
  };

  return (
    <div className="min-h-screen pulse-bg">
      <header className="p-4 flex items-center justify-between">
        <div className="flex items-center gap-4">
          <Link to="/" className="text-white hover:text-secondary">
            <ArrowLeft className="h-6 w-6" />
          </Link>
          <Logo />
        </div>
        <div className="flex gap-4">
          <Link to="/login">
            <Button variant="outline" className="glow-effect bg-white/90">
              Login
            </Button>
          </Link>
        </div>
      </header>

      <main className="container mx-auto px-4 py-8">
        <div className="text-center mb-8">
          <h1 className="text-4xl md:text-5xl font-bold text-white mb-4 bounce-in">
            Book Your Eco Ride
          </h1>
          <p className="text-lg text-white/90">
            Choose your locations and let's get you moving sustainably!
          </p>
        </div>

        <div className="grid lg:grid-cols-2 gap-8 max-w-6xl mx-auto">
          <Card className="bg-white/95 backdrop-blur-sm shadow-xl">
            <CardHeader>
              <CardTitle className="text-2xl text-primary flex items-center gap-2">
                <MapPin className="h-6 w-6" />
                Trip Details
              </CardTitle>
              <CardDescription>
                Select your pickup and destination points
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="space-y-2">
                <Label htmlFor="start-location">Pickup Location</Label>
                <Select value={startLocation} onValueChange={setStartLocation}>
                  <SelectTrigger className="h-12">
                    <SelectValue placeholder="Select pickup location" />
                  </SelectTrigger>
                  <SelectContent>
                    {locations.map((location) => (
                      <SelectItem key={location} value={location}>
                        {location}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-2">
                <Label htmlFor="end-location">Destination</Label>
                <Select value={endLocation} onValueChange={setEndLocation}>
                  <SelectTrigger className="h-12">
                    <SelectValue placeholder="Select destination" />
                  </SelectTrigger>
                  <SelectContent>
                    {locations.map((location) => (
                      <SelectItem key={location} value={location}>
                        {location}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              <div className="pt-4">
                <Button 
                  onClick={handleBooking}
                  disabled={!startLocation || !endLocation}
                  className="w-full h-12 text-lg font-semibold glow-effect"
                >
                  Check Out
                </Button>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-white/95 backdrop-blur-sm shadow-xl">
            <CardHeader>
              <CardTitle className="text-2xl text-accent">
                Route Map
              </CardTitle>
              <CardDescription>
                Visual representation of your journey
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="aspect-video bg-gradient-to-br from-primary/10 to-accent/10 rounded-lg border-2 border-dashed border-primary/30 flex items-center justify-center">
                <div className="text-center">
                  <MapPin className="h-16 w-16 text-primary/50 mx-auto mb-4" />
                  <p className="text-lg font-semibold text-muted-foreground">
                    Mapbox Placeholder
                  </p>
                  <p className="text-sm text-muted-foreground">
                    Interactive map will appear here
                  </p>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        <div className="mt-12 text-center">
          <Card className="bg-gradient-to-r from-primary to-accent text-white max-w-2xl mx-auto">
            <CardContent className="p-6">
              <h3 className="text-2xl font-bold mb-2">Why Choose AirBear?</h3>
              <div className="grid md:grid-cols-3 gap-4 text-sm">
                <div>
                  <div className="text-2xl mb-2">🌞</div>
                  <p>100% Solar Powered</p>
                </div>
                <div>
                  <div className="text-2xl mb-2">🍿</div>
                  <p>Onboard Snacks</p>
                </div>
                <div>
                  <div className="text-2xl mb-2">🌱</div>
                  <p>Zero Emissions</p>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>
      </main>
    </div>
  );
};

export default BookRide;