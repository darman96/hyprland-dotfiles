import { Box, BoxProps, StyleProps } from "@chakra-ui/react";
import {
  PropsWithChildren,
  useCallback,
  useEffect,
  useRef,
  useState,
} from "react";

interface Props extends BoxProps {
  ratio: number;
  direction: "Left" | "Right" | "Both";
  borderWidth: number;
}

interface CanvasProps {
  width: number;
  height: number;
  borderWidth: number;
  borderColor: string;
  backgroundColor: string;
  direction: "Left" | "Right";
}

const Canvas: React.FC<CanvasProps> = (props) => {
  const {
    width,
    height,
    borderWidth,
    borderColor,
    backgroundColor,
    direction,
  } = props;
  const canvasRef = useRef<HTMLCanvasElement>(null);

  const drawLeftAngle = useCallback(
    (ctx: CanvasRenderingContext2D) => {
      ctx.beginPath();
      ctx.moveTo(width, height);
      ctx.lineTo(0, 0);
      ctx.lineTo(width, 0);
      ctx.fillStyle = backgroundColor;
      ctx.fill();
      ctx.beginPath();
      ctx.moveTo(width, height);
      ctx.lineTo(0, 0);
      ctx.strokeStyle = borderColor;
      ctx.lineWidth = borderWidth;
      ctx.stroke();
    },
    [backgroundColor, borderColor, borderWidth, height, width],
  );

  const drawRightAngle = useCallback(
    (ctx: CanvasRenderingContext2D) => {
      ctx.beginPath();
      ctx.moveTo(0, 0);
      ctx.lineTo(0, height);
      ctx.lineTo(width, 0);
      ctx.fillStyle = backgroundColor;
      ctx.fill();
      ctx.beginPath();
      ctx.moveTo(0, height);
      ctx.lineTo(width, 0);
      ctx.strokeStyle = borderColor;
      ctx.lineWidth = borderWidth;
      ctx.stroke();
    },
    [backgroundColor, borderColor, borderWidth, height, width],
  );

  useEffect(() => {
    const canvas = canvasRef.current;
    if (canvas) {
      const ctx = canvas.getContext("2d");
      if (ctx) {
        if (direction == "Left") {
          drawLeftAngle(ctx);
        } else {
          drawRightAngle(ctx);
        }
      }
    }
  }, [
    direction,
    drawLeftAngle,
    drawRightAngle,
    canvasRef.current?.offsetWidth,
  ]);

  return <canvas ref={canvasRef} width={width} height={height} />;
};

export const TaperedBox: React.FC<PropsWithChildren<Props>> = (props) => {
  const { children, ratio, borderWidth, direction, ...boxProps } = props;
  const [boxHeight, setBoxHeight] = useState(0);
  const [boxBorderColor, setBoxBorderColor] = useState("");
  const [boxBackgroundColor, setBoxBackgroundColor] = useState("");
  const boxRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (boxRef.current) {
      const computedStyle = getComputedStyle(boxRef.current);
      setBoxHeight(boxRef.current.offsetHeight);
      setBoxBorderColor(computedStyle.borderBottomColor);
      setBoxBackgroundColor(computedStyle.backgroundColor);
    }
  }, [boxRef.current?.offsetHeight]);

  const canvasStyle: Omit<CanvasProps, "direction"> = {
    height: boxHeight,
    width: ratio * boxHeight,
    borderWidth: borderWidth,
    borderColor: boxProps.borderColor?.toString() ?? "",
    backgroundColor: boxBackgroundColor,
  };

  const rootStyle: BoxProps = {
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
  };

  const contentBoxStyle: BoxProps = {
    ...boxProps,
    border: `${borderWidth}px solid ${boxProps.borderColor}`,
    borderLeft: "none",
    borderRight: "none",
    borderTop: "none",
  };

  return (
    <Box {...rootStyle}>
      {(direction === "Left" || direction === "Both") && (
        <Canvas {...canvasStyle} direction="Left" />
      )}
      <Box ref={boxRef} {...contentBoxStyle}>
        {children}
      </Box>
      {(direction === "Right" || direction === "Both") && (
        <Canvas {...canvasStyle} direction="Right" />
      )}
    </Box>
  );
};

export default TaperedBox;
