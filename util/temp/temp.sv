/*
*******************************************************************************
* File:        agsL3IgrStrpIPSecAhTunnTest.sv
*
* Author:       Mangesh Thakare <mthakare@cisco.com>
* Created:      Mar 17, 2010
* Language:     SystemVerilog
*
* Copyright 2009 Cisco Systems, Inc., All Rights Reserved.
* Cisco Systems Confidential
*
*******************************************************************************
* Description:
********************************************************************************
*/
`include "gsTestAndEnvDefine.svh"


`GS_DEFINE_TEST_AND_ENV(AgsL3IgrStrpIPSecAhTunnTest, AgsEnv, AgsCfg)
`AGS_DEFINE_CNSTR_SCENARIO(AgsL3IgrStrpIPSecAhTunnTest,AgsIpSecAhTunnScenario);
extends agsL3IgrStrpIPSecAhTunnTestCfgCnstr(AgsL3IgrStrpIPSecAhTunnTestCfg);
  
  constraint AgsL3IgrStrpIPSecAhTunnTestChannelIdCnstr {
    foreach(channelIds[i]) {
      channelIds[i] == i;
    }
  }
   
endextends


extends agsIpSecAhTunnScenario(AgsL3IgrStrpIPSecAhTunnTestScenario);
  constraint ipSecAhTunnScenarioKindCnstr {
    scenario_kind == ipSecIpv4AhTunnScenId;
//      scenario_kind inside { ipSecIpv4AhTunnScenId, ipSecIpv4CmdAhTunnScenId, ipSecIpv6AhTunnScenId, ipSecIpv6CmdAhTunnScenId};
  }
  constraint agsL3IgrStrpIPSecAhTunnTestCnstr {
    foreach(items[i]) {  
      `SET_SCENARIO(i,decapsulate)          == 1; 
      `SET_SCENARIO(i,decrypt)              == 0; 
      `SET_SCENARIO(i,authenticate)         == 1; 
      `SET_SCENARIO(i,byteCntActionMask)    == SECURE_PROCESS; 
      `SET_SCENARIO(i,stripOuterIp)         == 1;
    }
  } 
endextends




extends agsL3IgrStrpIPSecAhTunnTestEnv(AgsL3IgrStrpIPSecAhTunnTestEnv);
  constraint AgsL3IgrStrpIPSecAhTunnTestGeneratorCnstr {
    foreach(agsFlowGen[i]) {
        agsFlowGen[i].stopAfterNInsts == 1;
        agsPktGen[i].stopAfterNInsts  == 1;
    }
  }

  after virtual function void build();

    AgsL3IgrStrpIPSecAhTunnTestScenario ipSecAhTunn;
    ipSecAhTunn = new();
    ipSecAhTunn.allocate_scenario();

    foreach(ipSecAhTunn.items[i]) begin
      `PKT_CRYPT(i,ipSecAhTunn,encrypt)       = 0;
      `PKT_CRYPT(i,ipSecAhTunn,authenticate)  = 1;
    end

    agsFlowGen[0].agsCnstrScenGen.scenario_set[0] = ipSecAhTunn ;
  endfunction : build

endextends
