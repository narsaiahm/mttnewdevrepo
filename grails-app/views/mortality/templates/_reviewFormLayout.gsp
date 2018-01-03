<%@ page import="org.mountsinai.mortalitytriggersystem.MortalityConstants" %>
<%@ page import="org.mountsinai.mortalitytriggersystem.AdminConstants" %>
<g:if test="${mReviewForm}">
    <form id="mReviewForm" method="POST">
        <div class="container">
            <div>
                <div class="main_div" style="min-height: 620px">
                    <div class="top_div row col-md-12">
                        <div class="innertop_div col-sm-1 center textPadding star clicked first"
                             data-divid="patInfo" onclick="divVisibility(this, 'patInfo');">
                            Patient Information</div>

                        <div onclick="divVisibility(this, 'majComorb');"
                             class="innertop_div col-sm-1 center textPadding star"
                             data-divid="majComorb">Major Comorbidities POA</div>

                        <div onclick="divVisibility(this, 'compAcqHosp');"
                             class="innertop_div col-sm-1 center textPadding star"
                             data-divid="compAcqHosp">Complication Acquired in  Hospital</div>

                        <div onclick="divVisibility(this, 'majSuppInter');"
                             class="innertop_div col-sm-1 center textPadding star" data-divid="majSuppInter">Major
                        Supportive Interventions
                        </div>

                        <div onclick="divVisibility(this, 'majInvInter');"
                             class="innertop_div col-sm-1 center textPadding star" data-divid="majInvInter">Major
                        Invasive Interventions
                        </div>

                        <div onclick="divVisibility(this, 'procRelComp');"
                             class="innertop_div col-sm-1 center textPadding star" data-divid="procRelComp">Procedure
                        Related Complication
                        </div>


                        <div onclick="divVisibility(this, 'causeOfDeath');"
                             class="innertop_div col-sm-1 center textPadding star"
                             data-divid="causeOfDeath">Cause of Death
                        </div>

                        <div onclick="divVisibility(this, 'contrFactors');"
                             class="innertop_div col-sm-1 center textPadding star"
                             data-divid="contrFactors">Contributing Factors</div>

                        <div onclick="divVisibility(this, 'addRevReq');"
                             class="innertop_div col-sm-1 center textPadding star last"
                             data-divid="addRevReq">Additional Review Required
                        </div>
                    </div>

                    <div class="inner_div row minHeight col-md-12">

                        <div id="patInfo" class="tabDiv" style="margin-top: 2.8%;">
                            <g:render template="/mortality/templates/patInfo"></g:render>
                        </div>

                        <div id="majComorb" class="tabDiv dropReadOnly " style="display: none;">
                            <g:render template="/mortality/templates/majComorb"></g:render>
                        </div>

                        <div id="compAcqHosp" class="tabDiv dropReadOnly" style="display: none;">
                            <g:render template="/mortality/templates/compAcqHosp"></g:render>
                        </div>

                        <div id="majSuppInter" class="tabDiv dropReadOnly" style="display: none;">
                            <g:render template="/mortality/templates/majSuppInter"></g:render>
                        </div>

                        <div id="majInvInter" class="tabDiv dropReadOnly" style="display: none;">
                            <g:render template="/mortality/templates/majInvInter"></g:render>
                        </div>

                        <div id="procRelComp" class="tabDiv dropReadOnly" style="display: none;">
                            <g:render template="/mortality/templates/procRelComp"></g:render>
                        </div>

                        <div id="causeOfDeath" class="tabDiv dropReadOnly" style="display: none;">
                            <g:render template="/mortality/templates/causeOfDeath"></g:render>
                        </div>

                        <div id="contrFactors" class="tabDiv dropReadOnly" style="display: none;">
                            <g:render template="/mortality/templates/contrFactors"></g:render>
                        </div>

                        <div id="addRevReq" class="tabDiv dropReadOnly" style="display: none;">
                            <g:render template="/mortality/templates/addRevReq"></g:render>
                        </div>

                    </div>
                </div>

                <div class="col-md-12"><center><span id="warningMsgDivId">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
                </center></div>

                <div class="col-md-12" style="margin-top: 20px">

                    <div class="col-md-9">

                        <g:if test="${(session?.user?.role?.roleName.equals(AdminConstants.ADMIN))}">
                            <g:link class="btn btn-primary cancelButton radio-inline"
                                    action="adminDashboard">Cancel</g:link>
                        </g:if>
                        <g:elseif test="${!(session?.user?.role?.roleName.equals(AdminConstants.ADMIN))}">
                            <g:link class="btn btn-primary cancelButton radio-inline"
                                    action="qlDashboard">Cancel</g:link>
                        </g:elseif>

                        <g:if test="${(session?.user?.role?.roleName.equals(AdminConstants.ADMIN))}">
                            <g:if test="${(mReviewForm?.status.status.equals(MortalityConstants.UNASSIGNED))}">
                                <g:link class="btn btn-primary radio-inline" action="assignReviewForm"
                                        params="[reviewId: mReviewForm.id, reviewFacilityCode: mReviewForm?.facility?.facilityCode, status: mReviewForm?.status, patientName: mReviewForm?.patientName, mrn: mReviewForm?.mrn, lead: mReviewForm?.lead?.id, role: mReviewForm?.lead?.role?.roleName, expiredDateTime: mReviewForm?.expiredDateTime, isReviewForm: true]"
                                        onclick="return formStatus('${session?.user?.role?.roleName}')">
                                    Assign
                                </g:link>
                            </g:if>
                            <g:if test="${(mReviewForm?.status.status.equals(MortalityConstants.ASSIGNED) || mReviewForm?.status.status.equals(MortalityConstants.ACCEPTED) || mReviewForm?.status.status.equals(MortalityConstants.UPDATED) || mReviewForm?.status.status.equals(MortalityConstants.REASSIGNED))}">
                                <g:link class="btn btn-primary radio-inline" action="assignReviewForm"
                                        params="[reviewId: mReviewForm.id, reviewFacilityCode: mReviewForm?.facility?.facilityCode, status: mReviewForm?.status, patientName: mReviewForm?.patientName, mrn: mReviewForm?.mrn, lead: mReviewForm?.lead?.id, role: mReviewForm?.lead?.role?.roleName, expiredDateTime: mReviewForm?.expiredDateTime, isReviewForm: true]"
                                        onclick="return formStatus('${session?.user?.role?.roleName}')">
                                    Reassign
                                </g:link>
                            </g:if>
                        </g:if>
                        <g:elseif
                                test="${session?.user?.email?.toString().toLowerCase().equals(mReviewForm?.lead?.email?.toString()?.toLowerCase())}">%{--checking the access permission for the current user.  --}%

                            <g:if test="${(mReviewForm?.status.status.equals(MortalityConstants.ASSIGNED) || mReviewForm?.status.status.equals(MortalityConstants.REASSIGNED))}">
                                <button type="button" class="btn btn-primary cancelButton radio-inline"
                                        onclick="acceptReviewForm(${mReviewForm.id}, '${mReviewForm.status}');">Accept</button>
                            </g:if>

                            <g:if test="${(mReviewForm?.status.status.equals(MortalityConstants.ASSIGNED) || mReviewForm?.status.status.equals(MortalityConstants.ACCEPTED) || mReviewForm?.status.status.equals(MortalityConstants.UPDATED) || mReviewForm?.status.status.equals(MortalityConstants.REASSIGNED))}">
                                <g:link class="btn btn-primary radio-inline" action="assignReviewForm"
                                        params="[reviewId: mReviewForm.id, reviewFacilityCode: mReviewForm?.facility?.facilityCode, status: mReviewForm?.status, patientName: mReviewForm?.patientName, mrn: mReviewForm?.mrn, lead: mReviewForm?.lead?.id, role: mReviewForm?.lead?.role?.roleName, expiredDateTime: mReviewForm?.expiredDateTime, isReviewForm: true]"
                                        onclick="return formStatus('${session?.user?.role?.roleName}')">
                                    Reassign
                                </g:link>
                            </g:if>
                            <g:if test="${(mReviewForm?.status.status.equals(MortalityConstants.ACCEPTED) || mReviewForm?.status.status.equals(MortalityConstants.UPDATED))}">
                                <button type="button" id="watch-Submit"
                                        class="btn btn-primary radio-inline " ${mReviewForm?.status.status.equals(MortalityConstants.ACCEPTED) ? "style='display:none'" : ''}>Save</button>
                            </g:if>
                            <g:if test="${!(session?.user?.role?.roleName.equals(AdminConstants.ADMIN))}">
                                <g:actionSubmit value="Save and Review" id="show-Submit"
                                                class="btn btn-primary radio-inline inputEnable"
                                                action="saveAndReview"
                                                onclick="return assignValToStatusChangeTo()"
                                                style="display: none">Save and Review</g:actionSubmit>
                            </g:if>
                            <g:actionSubmit value="Submit" id="showSubmit" action="submitFormThroughHospiceOption"
                                            class="btn btn-primary dropReadOnly"
                                            name="formSubmitInReview"
                                            onclick="return submitThroughHospiceOption()"
                                            onmouseover="showWarning()"
                                            onmouseout="hideWarning()" style="display: none">Submit</g:actionSubmit>
                        </g:elseif>
                    %{--<g:else>
                        <center>  <span style="color: red">You're not authorised to edit this form.</span></center>
                    </g:else>--}%
                    </div>

                    <div class="hideHospiceYes col-md-3">
                        <button type="button" class="btn btn-primary nextBtn radio-inline floatToRight"
                                onclick="moveTab(1)">Next <span
                                class="glyphicon glyphicon-forward"></span></button>

                        <button type="button" class="btn btn-primary hide prevBtn radio-inline floatToRight"
                                onclick="moveTab(0)"><span
                                class="glyphicon glyphicon-backward"></span> Prev</button>
                    </div>

                </div>
            </div>
        </div>
        <g:hiddenField name="statusChangeTo" id="statusChangeTo" class="inputEnable"></g:hiddenField>
        <g:hiddenField name="userRole" id="userRole" class="inputEnable" value="${session?.user?.role?.roleName}"></g:hiddenField>
        <g:hiddenField id="isFormEditable" name="isFormEditable" class="inputEnable"
                       value="${isFormEditable}"></g:hiddenField>
        <g:hiddenField name="reviewId"  class="inputEnable" value="${mReviewForm.id}"></g:hiddenField>
        <g:hiddenField name="status"  class="inputEnable" id="status" value="${mReviewForm.status}"></g:hiddenField>
        <div  id="reassignWarning">
            <g:render template="/mortality/templates/reassignWarningMsg"></g:render>
        </div>
        <div id="hospiceServiceSubmit">
            <g:render template="/mortality/templates/hospiceQuesSubmitConfirmation"></g:render>
        </div>

    </form>
</g:if>
<g:else>
    No Data To Show
</g:else>