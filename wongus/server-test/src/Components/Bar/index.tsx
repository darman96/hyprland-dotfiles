import { useEffect, useState } from "react";
import { Box, BoxProps, Text } from "@chakra-ui/react";
import TaperedBox from "../TaperedBox";

interface Props {}

const rootStyle: BoxProps = {
  display: "flex",
  justifyContent: "space-between",
  alignItems: "stretch",
  color: "white",
  width: "100vw",
  height: "100vh",
};

const barSegmentStyle: BoxProps = {
  borderColor: "aqua",
  padding: "0.4rem",
  background: "rgba(35,35,35,1)",
  height: "100vh",
};

const leftSegmentStyle: BoxProps = {
  borderLeft: "none",
};

const centerSegmentStyle: BoxProps = {
  display: "flex",
  justifyContent: "center",
  alignItems: "center",
};

const rightSegmentStyle: BoxProps = {
  borderRight: "none",
};

export const Bar: React.FC<Props> = (props) => {
  const [dateString, setDateString] = useState("");
  const [activeWindow, setActiveWindow] = useState("");

  useEffect(() => {
    const interval = setInterval(async () => {
      const dateResp = await wongus.run_command({
        command: ["date", "+%d %b - %H:%M:%S"],
        timeout_secs: 1,
      });

      const windowResp = await wongus.run_command({
        command: [
          "hyprctl",
          "activewindow",
          "|",
          "sed -n -e 's/^s*title: //p'",
        ],
        timeout_secs: 1,
      });

      setDateString(dateResp.stdout);
      setActiveWindow(windowResp.stdout);
    }, 1000);
  }, []);

  return (
    <Box {...rootStyle}>
      <TaperedBox
        {...barSegmentStyle}
        {...leftSegmentStyle}
        borderWidth={2}
        ratio={1.2}
        direction="Right"
      >
        {activeWindow}
      </TaperedBox>
      <TaperedBox
        {...barSegmentStyle}
        {...centerSegmentStyle}
        borderWidth={2}
        ratio={1.2}
        direction="Both"
      >
        <Text>{dateString}</Text>
      </TaperedBox>
      <TaperedBox
        {...barSegmentStyle}
        {...rightSegmentStyle}
        borderWidth={2}
        ratio={1.2}
        direction="Left"
      ></TaperedBox>
    </Box>
  );
};

export default Bar;
