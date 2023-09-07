import * as core from "@actions/core";
import * as exec from "@actions/exec";
import * as io from "@actions/io";

export async function run(): Promise<void> {
  const flags = core.getInput("flags");
  const outputDir = core.getInput("output-dir");
  const outputBin = core.getInput("output-bin");
  const packages = core.getInput("packages");

  core.debug(`creating directory tree '${outputDir}'`);
  await io.mkdirP(outputDir);

  await exec.exec(`go build ${flags}`, ["-o", `${outputDir}/${outputBin}`, packages]);
};

// run();
