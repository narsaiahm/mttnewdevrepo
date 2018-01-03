<%@ page import="org.mountsinai.mortalitytriggersystem.MortalityConstants" %>
<%@ page import="org.mountsinai.mortalitytriggersystem.AdminConstants" %>
<div align="center" class="heading_4" style="margin-top: -10px;">
    <span>Mortality Review Form</span>
</div>
<g:if test="${session?.user?.role?.roleName.equals(AdminConstants.ADMIN)}">
    <div align="center" style="margin-top: 5px"> ${latestStatus.updatedStatus}  by  ${latestStatus.updatedBy}  [${latestStatus.dateUpdated.format('MM/dd/yyyy hh:mm')}]</div>
</g:if>
<div class="main_div" style="margin-right: 40px;margin-left: 40px;">
    <div class="inner_div row">
        <form id="mReviewForm" method="post">
            <div class="tabDiv" id="patInfo">
                <g:render template="/mortality/templates/patInfo"></g:render>
            </div>

            <div class="tabDiv hideHospiceYes" id="majComorb">
                <g:render template="/mortality/templates/majComorb"></g:render>
            </div>

            <div class="tabDiv hideHospiceYes" id="compAcqHosp">
                <g:render template="/mortality/templates/compAcqHosp"></g:render>
            </div>

            <div class="tabDiv hideHospiceYes" id="majSuppInter">
                <g:render template="/mortality/templates/majSuppInter"></g:render>
            </div>

            <div class="tabDiv hideHospiceYes" id="majInvInter">
                <g:render template="/mortality/templates/majInvInter"></g:render>
            </div>

            <div class="tabDiv hideHospiceYes" id="procRelComp">
                <g:render template="/mortality/templates/procRelComp"></g:render>
            </div>

            <div class="tabDiv hideHospiceYes" id="causeOfDeath">
                <g:render template="/mortality/templates/causeOfDeath"></g:render>
            </div>

            <div class="tabDiv hideHospiceYes" id="contrFactors">
                <g:render template="/mortality/templates/contrFactors"></g:render>
            </div>

            <div class="tabDiv hideHospiceYes" id="addRevReq">
                <g:render template="/mortality/templates/addRevReq"></g:render>
            </div>

            <span  id="warningMsgDivId">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>

            <div class="col-sm-12">
                <div class="row margin">

                    <g:if test="${! ((mReviewForm?.status.status.equals(MortalityConstants.AMENDED) || mReviewForm?.status.status.equals(MortalityConstants.SUBMITTED)))}">
                        <g:if test="${(session?.user?.role?.roleName.equals(AdminConstants.ADMIN))}">
                            <g:link class="btn btn-primary cancelButton radio-inline" action="adminDashboard" >Close</g:link>
                        </g:if>
                        <g:elseif test="${(session?.user?.role?.roleName.equals(AdminConstants.QUALITY_LEAD) || session?.user?.role?.roleName.equals(AdminConstants.ADHOC))}">
                            <g:link class="btn btn-primary cancelButton radio-inline" action="qlDashboard" >Close</g:link>
                        </g:elseif>
                    </g:if>

                    <g:if test="${session?.user?.email?.toString().toLowerCase().equals(mReviewForm?.lead?.email?.toString()?.toLowerCase())}">  %{--checking the access permission for the current user.  --}%
                        <g:if test="${(mReviewForm?.status.status.equals(MortalityConstants.ACCEPTED) || mReviewForm?.status.status.equals(MortalityConstants.UPDATED))}">
                            <button value="Save" id="saveReviewFormButtonId" class="btn btn-primary save "
                                    name="formSaveInReview" onclick="return reviewAndSubmit(this)">Save</button>
                        </g:if>
                        <g:actionSubmit value="Submit" id="showSubmit" action="submitMortalityForm" class="btn btn-primary"
                                        name="formSubmitInReview" style="display:none;"
                                        onclick="return reviewAndSubmit(this)" onmouseover="showWarning()"
                                        onmouseout="hideWarning()">Submit</g:actionSubmit>
                    </g:if>

                    <g:hiddenField name="reviewId" value="${mReviewForm.id}" class="inputEnable"></g:hiddenField>
                    <g:hiddenField name="statusChangeTo" id="statusChangeTo" class="inputEnable"></g:hiddenField>
                    <g:hiddenField name="status" class="inputEnable" id="status"
                                   value="${mReviewForm.status}"></g:hiddenField>
                    <g:hiddenField name="isFormEditable" class="inputEnable" id="isFormEditable" value="${isFormEditable}"></g:hiddenField>
                </div>

            </div>
            <div id="hospiceServiceSubmit">
                <g:render template="/mortality/templates/hospiceQuesSubmitConfirmation"></g:render>
            </div>

        </form>

    </div>
</div>
