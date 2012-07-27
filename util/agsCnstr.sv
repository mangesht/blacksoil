/*
*******************************************************************************
* File:         agsCnstr.sv
*
* Author:       Mark Kujur <mkujur@cisco.com>
* Created:      Oct 23, 2009
* Language:     SystemVerilog
*
* Copyright 2009 Cisco Systems, Inc., All Rights Reserved.
* Cisco Systems Confidential
*
*******************************************************************************
* Description:
*******************************************************************************
*/

`ifndef __AGS_CNSTR__
`define __AGS_CNSTR__

`include "agsScenario.sv"

`ifdef DHL_
`include "dhlConstants.vh"
`else
`include "upsConstants.vh"
`endif


class AgsCnstr extends GsData ;
rand AgsPktXact      agsPktXac;
rand AgsScenario     agsScenario;

// Data structures
`ifdef DHL_
`ifdef EGR_
rand DhlAgsL2EluEltDataClass     eluEltData;
rand DhlAgsL2EluEltMskClass      eluEltMsk;
rand DhlAgsL2EluEsatDataClass    eluEsatData;
rand DhlAgsL2EluEartDataClass    eluEartData;
rand DhlAgsL2EluErtDataClass     eluErtData;
rand DhlAgsL2EncEhkyClass        encEhky;
rand DhlAgsL2EncEakyClass        encEaky;
`else
rand DhlAgsL2IluIltDataClass     iluIltData;
rand DhlAgsL2IluIltMskClass      iluIltMsk;
rand DhlAgsL2IluIsatDataClass    iluIsatData;
rand DhlAgsL2IluIartDataClass    iluIartData;
rand DhlAgsL2IdcEhkyClass        idcEhky;
rand DhlAgsL2IdcEakyClass        idcEaky;
`endif
`else
rand UpsAgsL3EluEartDataClass    eluEartData;
rand UpsAgsL3EluErtDataClass     eluErtData;
rand UpsAgsL3EncEhkyClass        encEhky;
rand UpsAgsL3EncEakyClass        encEaky;

rand UpsAgsL3IluIartDataClass    iluIartData;
rand UpsAgsL3IdcEhkyClass        idcEhky;
rand UpsAgsL3IdcEakyClass        idcEaky;
`endif

// Local variables
`ifdef DHL_
randc bit [`AGS_SA_OFFSET-1:0]  camOffset;
randc bit [`AGS_SA_OFFSET-1:0]  saiOffset;

rand int                camHitIdx;
rand int                saIdx; 

`else
int                     sysRxSaIdx = -1;
`ifdef EGR_
randc bit [`UPS_AGSL3_EGRSAIDXWD-1:0]    tempSysRxSaIdx;
`else
randc bit [`UPS_AGSL3_IGRSAIDXWD-1:0]    tempSysRxSaIdx;
`endif
`endif

int                      flowId = 0;

// constraints
constraint ethCnstr;
constraint outVlanCnstr;
constraint inVlanCnstr;
constraint vnTagCnstr;
constraint l2CtsCnstr;

constraint sysRxSaIdxCnstr;

`ifdef DHL_
`ifdef EGR_
constraint eltDataVldCnstr;
constraint eltDataEthCnstr;
constraint eltDataOutVlanCnstr;
constraint eltDataInVlanCnstr;
constraint eltDataVnTagCnstr;
`else
constraint iltDataVldCnstr;
constraint iltDataEthCnstr;
constraint iltDataOutVlanCnstr;
constraint iltDataInVlanCnstr;
constraint iltDataVnTagCnstr;
constraint iltDataL2CtsCnstr;
`endif
`endif

`ifdef EGR_
constraint eartDataSecFrActCnstr;
constraint eartDataUnsecFrActCnstr;
constraint eartDataBytCntActCnstr;
constraint eartDataSecProtoCnstr;
constraint eartDataSeqNumThPtrCnstr;
constraint eartDataEncapCnstr;
constraint eartDataEncryptCnstr;
constraint eartDataAuthCnstr;
constraint eartDataRplyModeCnstr;
constraint eartsecProcessTypeCnstr;
constraint ertDataCnstr;
constraint egressMaskCnstr; // TBD , ether type masked, revisit
`else
constraint iartDataAuthFlActCnstr; 
constraint iartDataRplyFlActCnstr; 
constraint iartDataSecFrActCnstr; 
constraint iartDataUnsecFrActCnstr; 
constraint iartDataBytCntMskCnstr; 
constraint iartDataSecProtoCnstr; 
constraint iartDataSeqNumThPtrCnstr; 
constraint iartDataStrpOuIpCnstr; 
constraint iartDataCapwapVerChkCnstr; 
constraint iartDataCapWapVerSelCnstr; 
constraint iartDataDecapCnstr; 
constraint iartDataDecryptCnstr; 
constraint iartDataAuthCnstr; 
constraint iartDataRplyModeCnstr; 
constraint iartDataRplyChkCnstr; 
constraint ertDataCnstr;
`endif

extern function new();
extern virtual function AgsPktXact getAgsPktXac() ;
extern function vmm_data copy(vmm_data to = null);
endclass : AgsCnstr


function AgsCnstr::new();
super.new();

agsPktXac    = new();
agsScenario  = new();

`ifdef DHL_
`ifdef EGR_
eluEltData  = new("eluEltData") ;
eluEltMsk   = new("eluEltMsk") ;
eluEsatData = new("eluEsatData") ;
eluEartData = new("eluEartData") ;
eluErtData  = new("eluErtData");
encEhky     = new("encEhky");
encEaky     = new("encEaky");
`else 
iluIltData  = new("iluIltData") ;
iluIltMsk   = new("iluIltMsk") ;
iluIsatData = new("iluIsatData") ;
iluIartData = new("iluIartData") ;
idcEhky     = new("idcEhky");
idcEaky     = new("idcEaky");
`endif // EGR_
`else
eluEartData = new("eluEartData") ;
eluErtData  = new("eluErtData");
encEhky     = new("encEhky");
encEaky     = new("encEaky");

iluIartData = new("iluIartData") ;
idcEhky     = new("idcEhky");
idcEaky     = new("idcEaky");
`endif
endfunction : new


function AgsPktXact AgsCnstr::getAgsPktXac() ;
AgsPktXact      agsPktXacCp;

`GS_ASSERT($cast(agsPktXacCp,this.agsPktXac.copy()),"Cast to AgsPktXact failed") ;

getAgsPktXac = agsPktXacCp; 
endfunction : getAgsPktXac


function vmm_data AgsCnstr::copy(vmm_data to = null);
AgsCnstr    localAgsCnstr;

if( to == null) begin
localAgsCnstr = new();
end
else if(!$cast(localAgsCnstr, to)) begin
copy = null;
return null;
end

super.copy_data(localAgsCnstr);

this.agsPktXac.copy(localAgsCnstr.agsPktXac) ;
this.agsScenario.copy(localAgsCnstr.agsScenario) ;
`ifdef DHL_
localAgsCnstr.camOffset = this.camOffset ;
localAgsCnstr.saiOffset = this.saiOffset;
localAgsCnstr.camHitIdx = this.camHitIdx;
localAgsCnstr.saIdx     = this.saIdx;

`ifdef EGR_
localAgsCnstr.eluEltData  = this.eluEltData ;
localAgsCnstr.eluEltMsk   = this.eluEltMsk ;
localAgsCnstr.eluEsatData = this.eluEsatData ;
localAgsCnstr.eluEartData = this.eluEartData ;
localAgsCnstr.eluErtData  = this.eluErtData;
localAgsCnstr.encEhky     = this.encEhky;
localAgsCnstr.encEaky     = this.encEaky;
`else
localAgsCnstr.iluIltData  = this.iluIltData ;
localAgsCnstr.iluIltMsk   = this.iluIltMsk ;
localAgsCnstr.iluIsatData = this.iluIsatData ;
localAgsCnstr.iluIartData = this.iluIartData ;
localAgsCnstr.idcEhky     = this.idcEhky;
localAgsCnstr.idcEaky     = this.idcEaky;
`endif // EGR_
`else
localAgsCnstr.sysRxSaIdx     = this.sysRxSaIdx;
localAgsCnstr.tempSysRxSaIdx = this.tempSysRxSaIdx;
`ifdef EGR_
localAgsCnstr.eluEartData = this.eluEartData ;
localAgsCnstr.eluErtData  = this.eluErtData;
localAgsCnstr.encEhky     = this.encEhky;
localAgsCnstr.encEaky     = this.encEaky;
`else
localAgsCnstr.iluIartData = this.iluIartData ;
localAgsCnstr.idcEhky     = this.idcEhky;
localAgsCnstr.idcEaky     = this.idcEaky;
`endif
`endif

return(localAgsCnstr); 
endfunction : copy


/////////////////////////////////////////////////////////////////////
// End TCAM constraints
`ifdef DHL_
constraint AgsCnstr::ethCnstr {
    solve agsPktXac.agsPktCfg.hdrCfg[PktEncapConstraints::Eth].repCnt
    before agsPktXac.agsSvplCnstr.isEth ;
    
    agsPktXac.agsSvplCnstr.isEth == agsPktXac.agsPktCfg.hdrCfg[PktEncapConstraints::Eth].repCnt ;
}

constraint AgsCnstr::outVlanCnstr {
    solve agsPktXac.agsPktCfg.hdrCfg[PktEncapConstraints::Tag1q].repCnt
    before agsPktXac.agsSvplCnstr.isTag1q ;
    
    agsPktXac.agsSvplCnstr.isTag1q == agsPktXac.agsPktCfg.hdrCfg[PktEncapConstraints::Tag1q].repCnt ;
}

constraint AgsCnstr::inVlanCnstr {
    solve agsPktXac.agsPktCfg.hdrCfg[PktEncapConstraints::InnerTag1q].repCnt
    before agsPktXac.agsSvplCnstr.isInnerTag1q ;
    
    agsPktXac.agsSvplCnstr.isInnerTag1q == agsPktXac.agsPktCfg.hdrCfg[PktEncapConstraints::InnerTag1q].repCnt ;
}

constraint AgsCnstr::vnTagCnstr {
    solve agsPktXac.agsPktCfg.hdrCfg[PktEncapConstraints::VnTag].repCnt  
    before agsPktXac.agsSvplCnstr.isVntag ; 
    
    agsPktXac.agsSvplCnstr.isVntag == agsPktXac.agsPktCfg.hdrCfg[PktEncapConstraints::VnTag].repCnt ;
}

constraint AgsCnstr::l2CtsCnstr {
    solve agsPktXac.agsPktCfg.hdrCfg[PktEncapConstraints::MacSec].repCnt  
    before agsPktXac.agsSvplCnstr.isL2Cts ; 
    
    agsPktXac.agsSvplCnstr.isL2Cts == agsPktXac.agsPktCfg.hdrCfg[PktEncapConstraints::MacSec].repCnt ;
}

`ifdef EGR_
constraint AgsCnstr::eltDataVldCnstr {
    solve agsScenario.camHit before eluEltData.entryValid; 
    
    (agsScenario.camHit == 1'b1) -> eluEltData.entryValid == 1'b1;
    (agsScenario.camHit == 1'b0) -> eluEltData.entryValid == 1'b0;
}

constraint AgsCnstr::eltDataEthCnstr {
    solve agsPktXac.agsSvplCnstr.da
    before eluEltData.macDa ;
    
    solve agsPktXac.agsSvplCnstr.sa
    before eluEltData.macSa ;
    
    solve agsPktXac.agsSvplCnstr.eth_type
    before eluEltData.etherType ;
    
    eluEltData.macDa     == agsPktXac.agsSvplCnstr.da ;
    eluEltData.macSa     == agsPktXac.agsSvplCnstr.sa ;
    eluEltData.etherType == agsPktXac.agsSvplCnstr.eth_type ; 
}

constraint AgsCnstr::eltDataOutVlanCnstr {
    solve agsPktXac.agsSvplCnstr.vlanArr[0]
    before eluEltData.outerVlanId;
    
    solve agsPktXac.agsPktCfg.hdrCfg[PktEncapConstraints::Tag1q].repCnt
    before eluEltData.outerVlanValid ;
    
    eluEltData.outerVlanId    == agsPktXac.agsSvplCnstr.vlanArr[0] ;
    eluEltData.outerVlanValid == agsPktXac.agsPktCfg.hdrCfg[PktEncapConstraints::Tag1q].repCnt ; 
}

constraint AgsCnstr::eltDataInVlanCnstr {
    solve agsPktXac.agsSvplCnstr.vlanArr[1]
    before eluEltData.innerVlanId ;
    
    solve agsPktXac.agsPktCfg.hdrCfg[PktEncapConstraints::InnerTag1q].repCnt
    before eluEltData.innerVlanValid ;
    
    eluEltData.innerVlanId    == agsPktXac.agsSvplCnstr.vlanArr[1] ;
    eluEltData.innerVlanValid == agsPktXac.agsPktCfg.hdrCfg[PktEncapConstraints::InnerTag1q].repCnt ;
}

constraint AgsCnstr::eltDataVnTagCnstr {
    solve agsPktXac.agsSvplCnstr.d
    before eluEltData.dir ; 
    
    solve agsPktXac.agsSvplCnstr.dst_vif
    before eluEltData.dstVif ; 
    
    solve agsPktXac.agsPktCfg.hdrCfg[PktEncapConstraints::VnTag].repCnt
    before eluEltData.dstVifDirValid ; 
    
    eluEltData.dir            == agsPktXac.agsSvplCnstr.d ;
    eluEltData.dstVif         == agsPktXac.agsSvplCnstr.dst_vif ;
    eluEltData.dstVifDirValid == agsPktXac.agsPktCfg.hdrCfg[PktEncapConstraints::VnTag].repCnt ;
}


constraint AgsCnstr::egressMaskCnstr { // TBD , ether type masked, revisit
    eluEltMsk.etherTypeMsk       == 'h0 ;
    eluEltMsk.entryValidMsk      == 'h1 ;
}

`else // EGR_

constraint AgsCnstr::iltDataVldCnstr {
    solve agsScenario.camHit before iluIltData.entryValid; 
    
    (agsScenario.camHit == 1'b1) -> iluIltData.entryValid == 1'b1;
    (agsScenario.camHit == 1'b0) -> iluIltData.entryValid == 1'b0;
}

constraint AgsCnstr::iltDataEthCnstr {
    solve agsPktXac.agsSvplCnstr.da
    before iluIltData.macDa ;
    
    solve agsPktXac.agsSvplCnstr.sa
    before iluIltData.macSa ;
    
    solve agsPktXac.agsSvplCnstr.eth_type
    before iluIltData.etherType ;
    
    iluIltData.macDa     == agsPktXac.agsSvplCnstr.da ;
    iluIltData.macSa     == agsPktXac.agsSvplCnstr.sa ;
    iluIltData.etherType == agsPktXac.agsSvplCnstr.eth_type ; 
}

constraint AgsCnstr::iltDataOutVlanCnstr {
    solve agsPktXac.agsSvplCnstr.vlanArr[0]
    before iluIltData.outerVlanId ;
    
    solve agsPktXac.agsPktCfg.hdrCfg[PktEncapConstraints::Tag1q].repCnt
    before iluIltData.outerVlanValid ;
    
    iluIltData.outerVlanId    == agsPktXac.agsSvplCnstr.vlanArr[0] ;
    iluIltData.outerVlanValid == agsPktXac.agsPktCfg.hdrCfg[PktEncapConstraints::Tag1q].repCnt ;
}

constraint AgsCnstr::iltDataInVlanCnstr {
    solve agsPktXac.agsSvplCnstr.vlanArr[1]
    before iluIltData.innerVlanId ;
    
    solve agsPktXac.agsPktCfg.hdrCfg[PktEncapConstraints::InnerTag1q].repCnt
    before iluIltData.innerVlanValid ;
    
    iluIltData.innerVlanId    == agsPktXac.agsSvplCnstr.vlanArr[1] ;
    iluIltData.innerVlanValid == agsPktXac.agsPktCfg.hdrCfg[PktEncapConstraints::InnerTag1q].repCnt ;
}

constraint AgsCnstr::iltDataVnTagCnstr {
    solve agsPktXac.agsSvplCnstr.d
    before iluIltData.dir ; 
    
    solve agsPktXac.agsSvplCnstr.src_vif
    before iluIltData.srcVif ; 
    
    solve agsPktXac.agsPktCfg.hdrCfg[PktEncapConstraints::VnTag].repCnt
    before iluIltData.srcVifDirValid ; 
    
    iluIltData.dir            == agsPktXac.agsSvplCnstr.d ;
    iluIltData.srcVif         == agsPktXac.agsSvplCnstr.src_vif ;
    iluIltData.srcVifDirValid == agsPktXac.agsPktCfg.hdrCfg[PktEncapConstraints::VnTag].repCnt ;
}

constraint AgsCnstr::iltDataL2CtsCnstr {
    solve agsPktXac.agsSvplCnstr.tci, agsPktXac.agsSvplCnstr.sci
    before iluIltData.sciTci ;
    
    solve agsPktXac.agsPktCfg.hdrCfg[PktEncapConstraints::MacSec].repCnt
    before iluIltData.sciTciValid ;
    
    iluIltData.sciTci      == {agsPktXac.agsSvplCnstr.sci, agsPktXac.agsSvplCnstr.tci} ;
    iluIltData.sciTciValid == agsPktXac.agsPktCfg.hdrCfg[PktEncapConstraints::MacSec].repCnt ;
}
`endif // EGR_
`endif // DHL_
// End TCAM constraints
/////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////
// EART
`ifdef EGR_

// TBD sci/iv_offset, salt, spi

constraint AgsCnstr::eartDataSecFrActCnstr {
    solve agsScenario.secFrameAction before eluEartData.secFrameAction.dropOrBypass; 
    
    eluEartData.secFrameAction.dropOrBypass == agsScenario.secFrameAction ;
}

constraint AgsCnstr::eartDataUnsecFrActCnstr {
    solve agsScenario.unsecFrameAction before eluEartData.unsecFrameAction.egrAction ; 
    
    eluEartData.unsecFrameAction.egrAction == agsScenario.unsecFrameAction ;
}

constraint AgsCnstr::eartDataBytCntActCnstr {
    solve agsScenario.byteCntActionMask before eluEartData.byteCntActionMask.egrAction ; 
    
    eluEartData.byteCntActionMask.egrAction == agsScenario.byteCntActionMask ;
}

constraint AgsCnstr::eartDataSecProtoCnstr {
    solve agsScenario.secProtocol before eluEartData.secProtocol.securityProtocol ; 
    
    eluEartData.secProtocol.securityProtocol == agsScenario.secProtocol ;
}

constraint AgsCnstr::eartDataSeqNumThPtrCnstr {
    solve agsScenario.seqNumThresholdPtr before eluEartData.seqNumThresholdPtr ; 
    
    eluEartData.seqNumThresholdPtr == agsScenario.seqNumThresholdPtr ;
}

constraint AgsCnstr::eartDataEncapCnstr {
    solve agsScenario.encapsulate before eluEartData.encapsulate ; 
    
    eluEartData.encapsulate == agsScenario.encapsulate ;
}

constraint AgsCnstr::eartDataEncryptCnstr {
    solve agsScenario.encrypt before eluEartData.encrypt ; 
    
    eluEartData.encrypt == agsScenario.encrypt ;
}

constraint AgsCnstr::eartDataAuthCnstr {
    solve agsScenario.authenticate before eluEartData.authenticate ; 
    
    eluEartData.authenticate == agsScenario.authenticate ;
}

constraint AgsCnstr::eartDataRplyModeCnstr {
    solve agsScenario.rplyModeOrDtlsVerPtr 
    before eluEartData.replayModeDtlsVer.AgsL3_EartDtlsVerPtr.dtlsVersionPtr,
    eluEartData.replayModeDtlsVer.AgsL3_EartReplayMode.replayMode ; 
    
    if (eluEartData.secProcessType && eluEartData.secProtocol.securityProtocol == 2'b11) {
        eluEartData.replayModeDtlsVer.unionSelect == UpsAgsL3EluEartDataReplayModeDtlsVerUnionClass::selAgsL3_EartDtlsVerPtr;
        eluEartData.replayModeDtlsVer.AgsL3_EartDtlsVerPtr.dtlsVersionPtr == agsScenario.rplyModeOrDtlsVerPtr ;
    } else {
        eluEartData.replayModeDtlsVer.unionSelect == UpsAgsL3EluEartDataReplayModeDtlsVerUnionClass::selAgsL3_EartReplayMode;
        eluEartData.replayModeDtlsVer.AgsL3_EartReplayMode.replayMode == agsScenario.rplyModeOrDtlsVerPtr;
    }
}

constraint AgsCnstr::eartsecProcessTypeCnstr {
    solve agsScenario.secProcType before eluEartData.secProcessType; 
    
    eluEartData.secProcessType == agsScenario.secProcType ;
}


`else // DHL_

constraint AgsCnstr::iartDataAuthFlActCnstr {
    solve agsScenario.authFailAction before iluIartData.authFailAction.dropOrBypass ; 
    
    iluIartData.authFailAction.dropOrBypass == agsScenario.authFailAction ;
}

constraint AgsCnstr::iartDataRplyFlActCnstr { 
    solve agsScenario.replayFailAction before iluIartData.replayFailAction.dropOrByOrRe ; 
    
    iluIartData.replayFailAction.dropOrByOrRe == agsScenario.replayFailAction;
}

constraint AgsCnstr::iartDataSecFrActCnstr {
    solve agsScenario.secFrameAction before iluIartData.secFrameAction.igrSecAction ; 
    
    iluIartData.secFrameAction.igrSecAction == agsScenario.secFrameAction ;
}

constraint AgsCnstr::iartDataUnsecFrActCnstr { 
    solve agsScenario.unsecFrameAction before iluIartData.unsecFrameAction.dropOrBypass ; 
    
    iluIartData.unsecFrameAction.dropOrBypass == agsScenario.unsecFrameAction ;
}

constraint AgsCnstr::iartDataBytCntMskCnstr { 
    solve agsScenario.byteCntActionMask before iluIartData.byteCntActionMask.igrAction ; 
    
    iluIartData.byteCntActionMask.igrAction == agsScenario.byteCntActionMask ;
}

constraint AgsCnstr::iartDataSecProtoCnstr { 
    solve agsScenario.secProtocol before iluIartData.secProtocol.securityProtocol ; 
    
    iluIartData.secProtocol.securityProtocol == agsScenario.secProtocol ;
}

constraint AgsCnstr::iartDataSeqNumThPtrCnstr { 
    solve agsScenario.seqNumThresholdPtr before iluIartData.seqNumThresholdPtr ; 
    
    iluIartData.seqNumThresholdPtr == agsScenario.seqNumThresholdPtr ;
}

constraint AgsCnstr::iartDataStrpOuIpCnstr {
    solve agsScenario.stripOuterIp before iluIartData.stripOuterIp ; 
    
    iluIartData.stripOuterIp == agsScenario.stripOuterIp ;
}

constraint AgsCnstr::iartDataCapwapVerChkCnstr { 
    solve agsScenario.CAPWAPVersionCheck before iluIartData.CAPWAPVersionCheck ; 
    
    iluIartData.CAPWAPVersionCheck == agsScenario.CAPWAPVersionCheck ;
}

// constraint AgsCnstr::iartDataCapWapVerSelCnstr; 
//   solve agsScenario. before iluIartData. ; 
// 
//   iluIartData. == agsScenario. ;
// }

constraint AgsCnstr::iartDataDecapCnstr { 
solve agsScenario.decapsulate before iluIartData.decapsulate ; 

iluIartData.decapsulate == agsScenario.decapsulate ;
}

constraint AgsCnstr::iartDataDecryptCnstr { 
solve agsScenario.decrypt before iluIartData.decrypt ; 

iluIartData.decrypt == agsScenario.decrypt ;
}

constraint AgsCnstr::iartDataAuthCnstr { 
solve agsScenario.authenticate before iluIartData.authenticate ; 

iluIartData.authenticate == agsScenario.authenticate ;
}

constraint AgsCnstr::iartDataRplyModeCnstr { 
solve agsScenario.replayMode before iluIartData.replayModeCfg.igrReplayMode ; 

iluIartData.replayModeCfg.igrReplayMode == agsScenario.replayMode ;
}

constraint AgsCnstr::iartDataRplyChkCnstr { 
solve agsScenario.replayCheck before iluIartData.replayCheck ; 

iluIartData.replayCheck == agsScenario.replayCheck ;
}
`endif // DHL_
/////////////////////////////////////////////////////////////////////



// ERT constraints
`ifdef EGR_
`ifdef DHL_

constraint AgsCnstr::ertDataCnstr {
solve eluEartData.secProcessType, eluEartData.secProtocol.securityProtocol,
agsScenario.confOffset, agsScenario.tciAn, agsScenario.packetNumber
before eluErtData.entryData.confOffset, eluErtData.entryData.tciAn,eluErtData.entryData.packetNumber;

if (!eluEartData.secProcessType && eluEartData.secProtocol.securityProtocol == 2'b00) {
    eluErtData.entryData.confOffset   == agsScenario.confOffset;
    eluErtData.entryData.tciAn        == agsScenario.tciAn;
    eluErtData.entryData.packetNumber == agsScenario.packetNumber;
}
}

`else // DHL_

constraint AgsCnstr::ertDataCnstr {
solve eluEartData.secProcessType, eluEartData.secProtocol.securityProtocol,
eluEartData.replayModeDtlsVer.AgsL3_EartReplayMode.replayMode
before eluErtData.entryData.l3Ert.dtlsErtEntry.epochCntr,
eluErtData.entryData.l3Ert.dtlsErtEntry.sequenceNumber,
eluErtData.entryData.l3Ert.rsnErtEntry.sequenceNumber,
eluErtData.entryData.l3Ert.esnErtEntry.sequenceNumber,
eluErtData.entryData.l3Ert.gvErtEntry.sid,
eluErtData.entryData.l3Ert.gvErtEntry.timeStampPtr,   
eluErtData.entryData.l3Ert.gvErtEntry.sequenceNumber ;

// DTLS
if (eluEartData.secProcessType && eluEartData.secProtocol.securityProtocol == 2'b11) {
    eluErtData.entryData.l3Ert.unionSelect                 == UpsAgsL3_L3ErtEntryL3ErtUnionClass::selDtlsErtEntry;
    eluErtData.entryData.l3Ert.dtlsErtEntry.epochCntr      == agsScenario.epochCntr ;
    eluErtData.entryData.l3Ert.dtlsErtEntry.sequenceNumber == agsScenario.rSequenceNumber ;
}

// RSN    
if (eluEartData.secProcessType && (eluEartData.secProtocol.securityProtocol <= 2'b10) && (eluEartData.replayModeDtlsVer.AgsL3_EartReplayMode.replayMode == 2'b00)) {
    eluErtData.entryData.l3Ert.unionSelect                 == UpsAgsL3_L3ErtEntryL3ErtUnionClass::selRsnErtEntry;
    eluErtData.entryData.l3Ert.rsnErtEntry.sequenceNumber  == agsScenario.rSequenceNumber ;
}

// ESN 
if (eluEartData.secProcessType && (eluEartData.secProtocol.securityProtocol == 2'b10 || 
eluEartData.secProtocol.securityProtocol == 2'b01) && eluEartData.replayModeDtlsVer.AgsL3_EartReplayMode.replayMode == 2'b01) {
    eluErtData.entryData.l3Ert.unionSelect                == UpsAgsL3_L3ErtEntryL3ErtUnionClass::selEsnErtEntry;
    eluErtData.entryData.l3Ert.esnErtEntry.sequenceNumber == agsScenario.eSequenceNumber ;
}

// GetVpn 
if (eluEartData.secProcessType && eluEartData.secProtocol.securityProtocol <= 2'b10 
&& eluEartData.replayModeDtlsVer.AgsL3_EartReplayMode.replayMode == 2'b10) {
    eluErtData.entryData.l3Ert.unionSelect               == UpsAgsL3_L3ErtEntryL3ErtUnionClass::selGvErtEntry;
    eluErtData.entryData.l3Ert.gvErtEntry.sid            == agsScenario.sid ;
    eluErtData.entryData.l3Ert.gvErtEntry.timeStampPtr   == agsScenario.timeStampPtr ;
    eluErtData.entryData.l3Ert.gvErtEntry.sequenceNumber == agsScenario.rSequenceNumber ;
}
}

`endif // DHL_
`endif // EGR_

`endif
