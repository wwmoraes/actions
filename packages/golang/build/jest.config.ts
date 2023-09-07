import type { Config } from 'jest';

const config: Config = {
  preset: "ts-jest",
  verbose: true,
  clearMocks: true,
  testEnvironment: "node",
  moduleFileExtensions: ["ts", "js"],
  testMatch: ["**/*.test.ts"],
  testPathIgnorePatterns: ["/node_modules/", "/dist/"],
  transform: {
    "^.+\\.ts$": "ts-jest"
  },
  coverageReporters: [
    "json-summary",
    "text",
    "lcov"
  ],
  collectCoverage: true,
  collectCoverageFrom: [
    "./*.ts"
  ],
  coveragePathIgnorePatterns: [
    "./*.config.ts"
  ]
};

export default config;
