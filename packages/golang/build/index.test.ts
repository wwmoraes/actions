// import { RunOptions, RunTarget } from 'github-action-ts-run-api';
import * as core from "@actions/core";
import * as exec from "@actions/exec";
import * as io from "@actions/io";

import * as index from "./index";

const getInputMock = jest.spyOn(core, "getInput");
const mkdirPMock = jest.spyOn(io, "mkdirP");
const execMock = jest.spyOn(exec, "exec");
const runMock = jest.spyOn(index, "run");
const debugMock = jest.spyOn(core, "debug");

describe("golang-build", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it("runs successfully", async () => {
    const inputs: Record<string, string> = {
      flags: "-race",
      "output-dir": "test-out",
      "output-bin": "test-bin",
      "packages": "./foo/bar/...",
    };

    getInputMock.mockImplementation((name) => inputs[name] || "");
    mkdirPMock.mockImplementation(async (_) => Promise.resolve());
    execMock.mockImplementation(async (_cmd, _args) => Promise.resolve(0));

    await index.run();

    // const target = RunTarget.mainJs("action.yml");
    // const options = RunOptions.create().setInputs(inputs);

    // const res = await target.run(options);

    expect(runMock).toHaveReturned();
    expect(debugMock).toHaveBeenCalledWith(`creating directory tree '${inputs["output-dir"]}'`);
    expect(mkdirPMock).toHaveBeenCalledWith(inputs["output-dir"]);
    expect(execMock).toHaveBeenCalledWith(
      `go build ${inputs["flags"]}`,
      [
        "-o",
        `${inputs["output-dir"]}/${inputs["output-bin"]}`,
        inputs["packages"]
      ]
    );

    // expect(res.commands.warnings).toHaveLength(0);
    // expect(res.error).toBeUndefined();
    // expect(res.isTimedOut).toEqual(false);
    // expect(res.isSuccess).toEqual(true);
    // expect(res.runnerWarnings).toHaveLength(0);
    // expect(res.exitCode).toEqual(0);
  });
});
