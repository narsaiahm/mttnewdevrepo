<%@ page import="org.mountsinai.mortalitytriggersystem.MortalityConstants" %>
<%@ page import="org.mountsinai.mortalitytriggersystem.AdminConstants" %>
<div>
    <p><span class="title">Patient Information</span>
    </p>
</div>


<div class="row">
    <div class="col-md-6">
        <div class="part1">
            <table class="personalInfoTable">
                <tr>
                    <td><span>Patient Name:</span>
                        <span><b>${mReviewForm?.patientName}</b></span>
                    </td>
                </tr>
                <tr>
                    <td>
                        <span>DOB:</span>
                        <span><b>${mReviewForm?.dob}</b></span>
                    </td>
                </tr>
                <tr><td>
                    <span>
                        Admit Date:</span>
                    <span><b>${mReviewForm?.admitDateTime?.format("MM/dd/yyyy HH:mm")}</b></span></td>
                </tr>

            </table>
        </div>

        <div class="part1">
            <table class="personalInfoTable">
                <tr>
                    <td>

                        <span>Discharge Diagnosis:</span>
                        <span><b>${mReviewForm?.dischargeDiagnosis}</b></span></td></tr>

                <tr>
                    <td><span>Hospital:</span>
                        <span><b>${mReviewForm?.facility?.facilityName}</b></span></td>
                </tr>
                <tr>
                    <td>
                        <span>
                            Discharge Attending:</span>
                        <span><b>${mReviewForm?.lastAttending}</b></span>
                    </td></tr>
                <tr><td>
                    <span>
                        Specialty:</span>
                    <span><b>
                        <g:if test="${mReviewForm?.status?.status.equals(MortalityConstants.UNASSIGNED)}">
                            ${mReviewForm?.hospService}
                        </g:if>
                        <g:else>
                            ${mReviewForm?.speciality?.specialityName}
                        </g:else>
                    </b></span></td></tr>

            </table>
        </div>
    </div>
    <input type="hidden" name="mrn" value="${mReviewForm?.mrn}">

    <div class="col-md-6">
        <div class="part1">
            <table class="personalInfoTable">
                <tr>
                    <td>

                        <span>MRN:</span>
                        <span><b>${mReviewForm?.mrn}</b></span></td></tr>

                <tr><td>
                    <span>Sex:</span>
                    <span><b>${mReviewForm?.gender}</b></span></td></tr>

                <tr><td>
                    <span>
                        Admitting Diagnosis:</span>
                    <span><b>${mReviewForm?.admittingDiagnosis}</b></span>
                </td></tr>

            </table>
        </div>

        <div class="part1">
            <table class="personalInfoTable">

                <tr>
                    <td>

                        <span>Discharge Date:</span>
                        <span><b>${mReviewForm?.expiredDateTime?.format("MM/dd/yyyy HH:mm")}</b></span></td></tr>
                <tr><td>
                    <span>Patient Unit at Death:</span>
                    <span><b>${mReviewForm?.dischargeUnit}</b></span></td></tr>
                <tr><td>
                    <span>
                        Discharging Department:</span>
                    <span><b>${mReviewForm?.speciality?.dept?.departmentName}</b></span></td></tr>
                <tr><td colspan="5">&nbsp;</td></tr>
            </table>

        </div>
    </div>
</div>
<g:if test="${(mReviewForm?.status.status.equals(MortalityConstants.UPDATED)) && (session?.user?.role?.roleName.equals(AdminConstants.QUALITY_LEAD) || session?.user?.role?.roleName.equals(AdminConstants.ADHOC))}">
    <span id="infoMesage" style="display: none">
        <p align="center"
           class="formMessage"><span><b>This screen allows you to review the answers provided and gives you an option to edit the answers
        </b></span></p>

        <p align="center" class="formMessage"
           style="   margin-top: -8px;"><span><b>before doing a submission at which point you will not be able to make further changes on your own.
        </b></span></p>
    </span>
</g:if>

<div id="amendmentDiv" style="display: none">
    <g:if test="${(mReviewForm?.status?.status.equals(MortalityConstants.SUBMITTED)) && (session?.user?.role?.roleName.equals(AdminConstants.QUALITY_LEAD) || session?.user?.role?.roleName.equals(AdminConstants.ADHOC))}">
        <center>
            <label class="checkboxTop">
                <span class="required ">*&nbsp;</span>
                Amendments :&nbsp;</label>


            <textarea maxlength="250" class="ax_default text_area inputEnable checkboxTop" id="amendmentCommentId"
                      name="comments"
                      style="min-height: 50px !important;min-width: 480px !important;">${mReviewForm?.comments}</textarea>

            <button value="Save" id="amendmentSaveId" class="btn btn-primary checkboxTop"
                    onclick="return amendmentSave()">Save</button>
            <button value="Cancel" class="btn btn-primary inputEnable checkboxTop"
                    onclick="return closeAmendDiv()">Cancel</button>
        </center>
        <center><span id="amendErrorId" class="errorMsg"
                      style="display: none">Please enter the amendment comments.</span>
        </center>
    </g:if>
</div>
<g:if test="${(mReviewForm?.status.status.equals(MortalityConstants.AMENDED))}">
    <center>
        <g:if test="${mReviewForm?.comments}">
            <label class="checkboxTop">
                <span class="required ">*&nbsp;</span>
                Amendments :&nbsp;</label>


            <textarea maxlength="250" class="ax_default text_area  checkboxTop"
                      name="comments"
                      style="min-height: 50px !important;min-width: 480px !important;">${mReviewForm?.comments}</textarea>
        </g:if>

    </center>
</g:if>

<div class="form-inline row">
    <div class="col-md-12">
        <table class="leftAlign tableAlign">

            <tr>
                <td class="col-md-5">
                    <span class="required">*&nbsp;</span>
                    <label>Is patient information above correct?</label>

                </td>
                <td class="col-md-7">
                    <label class="radio-inline">
                        <input type="radio" name="isPatInfoAccurate" id="isPatInfoAccurateYes"
                               class="mandatory dropReadOnly"
                               value="true" ${mReviewForm?.isPatInfoAccurate == true ? 'checked="checked"' : ''}
                               onclick="hideAppropriateAndRemoveMandatoryClass('isPatInfoAccurateNoTr')">Yes
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="isPatInfoAccurate" id="isPatInfoAccurateNo"
                               class="mandatory dropReadOnly"
                               value="false" ${mReviewForm?.isPatInfoAccurate == false ? 'checked="checked"' : ''}
                               onclick="showAppropriateAndAddMandatoryClass('isPatInfoAccurateNoTr')">No
                    </label>
                </td>
            </tr>

            <tr id='isPatInfoAccurateNoTr' ${mReviewForm?.isPatInfoAccurate == false ? "" : "style=display:none"}>
                <td class="col-md-5"><label></label></td>
                <td class="col-md-7"><span class="required checkboxTop">*&nbsp;</span>

                    <textarea maxlength="250" id="patInfoComment"
                              class="ax_default text_area ${mReviewForm?.isPatInfoAccurate == false ? "mandatory" : ''}  isPatInfoAccurateNoComment isPatInfoAccurateNoTrOption dropReadOnly"

                              placeholder="Please enter the correct information here"
                              name="patInfoComment">${mReviewForm?.patInfoComment}</textarea>
                </td>
            </tr>
            <tr>
                <td class="col-md-5">
                    <span class="required">*&nbsp;</span>
                    <label>Was patient transferred from another facility?</label>
                </td>
                <td class="col-md-7">
                    <label class="radio-inline">
                        <input type="radio" name="wasPatTransferredFacility" id="wasPatTransferredFacilityYes"
                               class="mandatory dropReadOnly"
                               value="true" ${mReviewForm?.wasPatTransferredFacility == true ? 'checked="checked"' : ''}
                               onclick="showAppropriateAndAddMandatoryClass('patTransferredYesTr')">Yes
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="wasPatTransferredFacility" id="wasPatTransferredFacilityNo"
                               class="mandatory dropReadOnly"
                               value="false" ${mReviewForm?.wasPatTransferredFacility == false ? 'checked="checked"' : ''}
                               onclick="hideAppropriateAndRemoveMandatoryClass('patTransferredYesTr')">No
                    </label>
                </td>
            </tr>
            <tr id="patTransferredYesTr" ${mReviewForm?.wasPatTransferredFacility ? "" : 'style=display:none'}>
                <td class="col-md-5">

                </td>
                <td class="col-md-7">
                    <span class="required check">*&nbsp;</span>
                    <textarea maxlength="250" id="patTransferredComment"
                              class="ax_default text_area ${mReviewForm?.wasPatTransferredFacility ? "mandatory" : ''}  wasPatTransferredFacilityYesComment patTransferredYesTrOption dropReadOnly"

                              placeholder="Please enter the name of the facility that the patient was transferred from"
                              name="patTransferredComment">${mReviewForm?.patTransferredComment}</textarea>
                </td>
            </tr>
            <tr>
                <td class="col-md-5">
                    <span class="required">*&nbsp;</span>
                    <label>Was the patient receiving Hospice services either in a facility <br>or at home prior to admission?
                    </label>
                </td>
                <td class="col-md-7">
                    <label class="radio-inline">
                        <input id='isHospiceYes' type="radio" name="isHospice" class="mandatory dropReadOnly Yes"
                               value="true" ${mReviewForm?.isHospice == true ? 'checked="checked"' : ''}
                               onclick="hospiceOptionClicked(this , ${session?.user?.role?.roleName})">Yes
                    </label>
                    <label class="radio-inline">
                        <input id='isHospiceNo' type="radio" name="isHospice" class="mandatory dropReadOnly No"
                               value="false" ${mReviewForm?.isHospice == false ? 'checked="checked"' : ''}
                               onclick="hospiceOptionClicked(this , ${session?.user?.role?.roleName})">No
                    </label>
                </td>
            </tr>
        </table>

        <div class="hideHospiceYes">
            <table class="leftAlign tableAlign">
                <tr>
                    <td class="col-md-5">
                        <span class="required">*&nbsp;</span>
                        <label>ICU stay?</label>
                    </td>
                    <td class="col-md-7">
                        <label class="radio-inline">
                            <input id="isIcuStayYesDiv" type="radio" name="isIcuStay" class="mandatory"
                                   value="true" ${mReviewForm?.isIcuStay == true ? 'checked="checked"' : ''}
                                   onclick="showAppropriateAndAddMandatoryClass('isIcuStayYesTr')">Yes
                        </label>
                        <label class="radio-inline">
                            <input id="isIcuStayNoDiv" type="radio" name="isIcuStay" class="mandatory"
                                   value="false" ${mReviewForm?.isIcuStay == false ? 'checked="checked"' : ''}
                                   onclick="hideAppropriateAndRemoveMandatoryClass('isIcuStayYesTr')">No
                        </label>
                    </td>
                </tr>

                <tr id="isIcuStayYesTr" ${mReviewForm?.isIcuStay ? "" : 'style=display:none'}>
                    <td class="col-md-5">
                        <span class="required check">*&nbsp;</span>
                        <label>Did the patient die &lt;24 hours after discharge from ICU?</label>
                    </td>
                    <td class="col-md-7">
                        <label class="radio-inline">
                            <input type="radio" name="isPatDiedLt24hrsDischarge"
                                   class="${mReviewForm?.isIcuStay ? "mandatory" : ''} isIcuStayYesTrOption"
                                   value="true" ${mReviewForm?.isPatDiedLt24hrsDischarge == true ? 'checked="checked"' : ''}>Yes
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="isPatDiedLt24hrsDischarge"
                                   class="${mReviewForm?.isIcuStay ? "mandatory" : ''} isIcuStayYesTrOption"
                                   value="false" ${mReviewForm?.isPatDiedLt24hrsDischarge == false ? 'checked="checked"' : ''}>No
                        </label>
                    </td>
                </tr>

                <tr>
                    <td class="col-md-5">
                        <span class="required check">*&nbsp;</span>
                        <label>Did death occur within 24 hours of admission?</label>
                    </td>
                    <td class="col-md-7">
                        <label class="radio-inline">

                            <input type="radio" name="isDeathWt24hrAdmission" class="mandatory"
                                   value="true" ${mReviewForm?.isDeathWt24hrAdmission == true ? 'checked="checked"' : ''}>Yes
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="isDeathWt24hrAdmission" class="mandatory"
                                   value="false" ${mReviewForm?.isDeathWt24hrAdmission == false ? 'checked="checked"' : ''}>No
                        </label>
                    </td>
                </tr>
                <tr>
                    <td class="col-md-5">
                        <span class="required">*&nbsp;</span>
                        <label>Did the case meet Medical Examiner Criteria for an autopsy?</label>
                    </td>

                    <td class="col-md-7">
                        <label class="radio-inline">
                            <input type="radio" name="wasCaseAptME" class="mandatory"
                                   value="true" ${mReviewForm?.wasCaseAptME == true ? 'checked="checked"' : ''}
                                   onclick="showAppropriateAndAddMandatoryClass('wasCaseAptMEYesTr');
                                   hideAppropriateAndRemoveMandatoryClass('wasCaseAptMENoTr');
                                   hideAppropriateAndRemoveMandatoryClass('isMetAutopsyYesTr');">Yes
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="wasCaseAptME" class="mandatory"
                                   value="false" ${mReviewForm?.wasCaseAptME == false ? 'checked="checked"' : ''}
                                   onclick="hideAppropriateAndRemoveMandatoryClass('wasCaseAptMEYesTr');
                                   showAppropriateAndAddMandatoryClass('wasCaseAptMENoTr');
                                   hideAppropriateAndRemoveMandatoryClass('wasCaseReqMeYesTr');">No
                        </label>
                    </td>
                </tr>
                <tr id='wasCaseAptMEYesTr' ${mReviewForm?.wasCaseAptME == true ? "" : 'style=display:none'}>
                    <td class="col-md-5">
                        <span class="required check">*&nbsp;</span>
                        <label>Was the case submitted to the Medical Examiner?</label>

                    </td>
                    <td class="col-md-7">
                        <label class="radio-inline">
                            <input type="radio" name="wasCaseReqMe"
                                   class="${mReviewForm?.wasCaseAptME == true ? "mandatory" : ''} wasCaseAptMEYesTrOption"
                                   value="true" ${mReviewForm?.wasCaseReqMe == true ? 'checked="checked"' : ''}
                                   onclick="showAppropriateAndAddMandatoryClass('wasCaseReqMeYesTr'), hideAppropriateAndRemoveMandatoryClass('wasCaseAptMENoTr'), hideAppropriateAndRemoveMandatoryClass('isMetAutopsyYesTr')">Yes
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="wasCaseReqMe"
                                   class="${mReviewForm?.wasCaseAptME == true ? "mandatory" : ''} wasCaseAptMEYesTrOption"
                                   value="false" ${mReviewForm?.wasCaseReqMe == false ? 'checked="checked"' : ''}
                                   onclick="hideAppropriateAndRemoveMandatoryClass('wasCaseReqMeYesTr'), showAppropriateAndAddMandatoryClass('wasCaseAptMENoTr')">No
                        </label>
                    </td>
                </tr>
                <tr id='wasCaseReqMeYesTr' ${mReviewForm?.wasCaseAptME == true ? "" : 'style=display:none'}>
                    <td class="col-md-5">
                        <span class="required check">*&nbsp;</span>
                        <label>Was it Accepted?</label>

                    </td>
                    <td class="col-md-7">
                        <label class="radio-inline">
                            <input type="radio" name="wasCaseAccptByME"
                                   class="${mReviewForm?.wasCaseAptME == true ? "mandatory" : ''} wasCaseReqMeYesTrOption"
                                   value="true" ${mReviewForm?.wasCaseAccptByME == true ? 'checked="checked"' : ''}>Yes
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="wasCaseAccptByME"
                                   class="${mReviewForm?.wasCaseAptME == true ? "mandatory" : ''} wasCaseReqMeYesTrOption"
                                   value="false" ${mReviewForm?.wasCaseAccptByME == false ? 'checked="checked"' : ''}>No
                        </label>
                    </td>
                </tr>
                <tr id='wasCaseAptMENoTr' ${mReviewForm?.wasCaseAptME == false ? "" : 'style=display:none'}>
                    <td class="col-md-5">
                        <span class="required">*&nbsp;</span>
                        <label>Did the case meet Medical Staff Criteria for a hospital autopsy?</label>
                    </td>
                    <td class="col-md-7">
                        <label class="radio-inline">
                            <input type="radio" name="isMetAutopsy"
                                   class="${mReviewForm?.wasCaseAptME == false ? "mandatory" : ''} wasCaseAptMENoTrOption"
                                   value="true" ${mReviewForm?.isMetAutopsy == true ? 'checked="checked"' : ''}
                                   onclick="showAppropriateAndAddMandatoryClass('isMetAutopsyYesTr')">Yes
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="isMetAutopsy"
                                   class="${mReviewForm?.wasCaseAptME == false ? "mandatory" : ''} wasCaseAptMENoTrOption"
                                   value="false" ${mReviewForm?.isMetAutopsy == false ? 'checked="checked"' : ''}
                                   onclick="hideAppropriateAndRemoveMandatoryClass('isMetAutopsyYesTr')">No
                        </label>
                    </td>
                </tr>
                <tr id="isMetAutopsyYesTr" style="display: none">
                    <td class="col-md-5">
                        <span class="required check">*&nbsp;</span>
                        <label>Was the autopsy performed?</label>
                    </td>
                    <td class="col-md-7">
                        <label class="radio-inline">
                            <input type="radio" name="isAutopsyPerformed"
                                   class="mandatory isMetAutopsyYesTrOption"
                                   value="true" ${mReviewForm?.isAutopsyPerformed == true ? 'checked="checked"' : ''}>Yes
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="isAutopsyPerformed"
                                   class="mandatory isMetAutopsyYesTrOption"
                                   value="false" ${mReviewForm?.isAutopsyPerformed == false ? 'checked="checked"' : ''}>No
                        </label>
                    </td>
                </tr>
                <tr>
                    <td class="col-md-5" style="vertical-align: top;">
                        <label><span class="">Primary reason for hospitalization at time of admission</span></label>
                    </td>
                    <td class="col-md-7">
                        <textarea maxlength="250" class="ax_default text_area  checkboxTop"
                                  name="primReasonTimeOfAdmission"
                                  placeholder="Please enter primary Dx at the time of admission">${mReviewForm?.primReasonTimeOfAdmission}</textarea>
                    </td>
                </tr>
                <tr>
                    <td class="col-md-5" style="vertical-align: top;">
                        <label><span class="">Brief Summary of Hospital Course</span></label>
                    </td>
                    <td class="col-md-7">
                        <textarea maxlength="250" class="ax_default text_area"
                                  name="summaryOfHospCourse">${mReviewForm?.summaryOfHospCourse}</textarea>
                    </td>
                </tr>
            </table>
        </div>

    </div>
</div>
