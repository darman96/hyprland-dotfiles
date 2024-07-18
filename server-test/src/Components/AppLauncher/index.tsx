import { Box, BoxProps, Text } from "@chakra-ui/react";

interface Props {}

const rootStyle: BoxProps = {
  display: "flex",
  justifyContent: "center",
  alignItems: "center",
  width: "100vw",
  height: "100vh",
};

export const AppLauncher: React.FC<Props> = (props) => {
  return (
    <Box {...rootStyle}>
      <Text>Hello Wongus!</Text>
    </Box>
  );
};

export default AppLauncher;
