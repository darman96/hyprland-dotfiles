import { background, ChakraProvider, extendTheme } from "@chakra-ui/react";
import AppLauncher from "@/Components/AppLauncher";
import { Bar } from "@/Components/Bar";

const theme = extendTheme({
  styles: {
    global: {
      body: {
        background: "transparent",
      },
    },
  },
});

export default function Home() {
  return (
    <ChakraProvider theme={theme}>
      <Bar />
    </ChakraProvider>
  );
}
