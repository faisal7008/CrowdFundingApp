import { ConnectWallet } from "@thirdweb-dev/react";
import React from "react";

export default function ConnectToWallet({fullWidth}) {
  return (
    <ConnectWallet
      style={{
        fontFamily: "Epilogue",
        fontWeight: "600",
        fontSize: "16px",
        lineHeight: "26px",
        color: "white",
        minHeight: "52px",
        paddingLeft: "1rem",
        paddingRight: "1rem",
        borderRadius: "10px",
        background: "#8c6dfd",
        width: `${fullWidth && '100%'}`,
      }}
    />
  );
}
