import { hardhatStarknetCompile, hardhatStarknetTest } from "../../utils/cli-functions";

hardhatStarknetCompile(["cairo1-contracts/contract1.cairo", "--add-pythonic-hints"]);
hardhatStarknetTest(["--no-compile test/cairo1/declare-v2.test.ts"]);
