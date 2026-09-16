import { css } from "uebersicht";

export const command = "git config user.name";
export const refreshFrequency = 60000;

export const className = css`
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  color: #fff;
  font-family: "Helvetica Neue", Helvetica, sans-serif;
  font-size: 11vw;
  font-weight: 900;
  letter-spacing: -0.03em;
  filter: drop-shadow(0 4px 24px rgba(0, 0, 0, 0.35));
  user-select: none;
  pointer-events: none;
`;

export const render = ({ output, error }) => {
  if (error || !output) return null;
  return <div>{output.trim()}</div>;
};
