import { Link } from "react-router-dom";
import airBearLogo from "@/assets/airbear-logo.png";

const Logo = () => {
  return (
    <Link to="/" className="inline-block">
      <img
        src={airBearLogo}
        alt="AirBear Logo"
        className="h-12 w-12 md:h-16 md:w-16 logo-glow"
      />
    </Link>
  );
};

export default Logo;