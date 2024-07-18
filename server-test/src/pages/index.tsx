import { ChakraProvider } from "@chakra-ui/react";
import AppLauncher from "@/Components/AppLauncher";

export default function Home() {
  return (
    <ChakraProvider>
      <AppLauncher />
    </ChakraProvider>
  );
}
