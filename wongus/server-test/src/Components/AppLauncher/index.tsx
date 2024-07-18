import { Box, BoxProps, Text } from "@chakra-ui/react";

interface Props {}

const rootStyle: BoxProps = {
  display: "flex",
  justifyContent: "center",
  alignItems: "center",
  width: "100vw",
  height: "100vh",
};

const centerBoxStyle: BoxProps = {
  padding: "8px",
  background:
    "linear-gradient(to right top, #051937, #004d7a, #008793, #00bf72, #a8eb12)",
  color: "white",
  width: "200px",
  height: "50px",
  borderRadius: "10px",
};

export const AppLauncher: React.FC<Props> = (props) => {
  return (
    <Box {...rootStyle}>
      <Box {...centerBoxStyle}>
        <Text textAlign={"center"}>Hello Wongus!</Text>
      </Box>
    </Box>
  );
};

export default AppLauncher;
