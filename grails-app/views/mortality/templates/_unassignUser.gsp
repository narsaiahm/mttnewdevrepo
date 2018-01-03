<%@ page import="org.mountsinai.mortalitytriggersystem.AdminConstants" %>
<form id="unassignUserFormId">

    <div class="col-md-12">
        <div class="col-md-6">
            <div class="row">
                <div class="form-group col-md-9">
                    <label class="control-label">Search for an Employee:</label>
                    <input class="form-control " type="text" value="" id="lead">
                    <g:select class="control-label hide" id="leadSelect" name="leadSelect" noSelection="['': '']"
                              from="${leadsMap}"
                              optionKey="key"
                              optionValue="value"/>

                </div>
            </div>

            <div class="row">
                <div class="form-group col-md-9">
                    <p id="empReq" style="color: red;"></p>
                </div>
            </div>

            <div class="row">
                <div class="form-group col-md-9">
                    <label class="control-label">Email:</label>
                    <input class="form-control " type="text" value="" readonly="true" id="unassign_email">
                </div>
            </div>

        </div>

        <div class="col-md-6">
            <div class="row">
                <div class="form-group col-md-6">
                    <label class="control-label">MSHS Hospital</label>
                    <input class="form-control " readonly="true" type="text" value="" id="unassign_facility">
                </div>
            </div>

            <div class="row">
                <div class="form-group col-md-6">
                    <label class="control-label">MSHS Department</label>
                    <input class="form-control " readonly="true" type="text" value="" id="unassign_department">

                </div>
            </div>

            <div class="row">
                <div class="form-group col-md-6">
                    <label class="control-label">Specialty</label>
                    <input class="form-control " readonly="true" type="text" value="" id="unassign_speciality">
                </div>
            </div>
        </div>
    </div>

    <div class="col-md-12">
        <p id="errorMsg" style="color: red;margin-left: 22%;"></p>
    </div>

     <div class="center buttonSection">
    <g:if test="${params?.isReassignForm == "false"}">
         <g:if test="${session?.user?.role?.roleName.equals(AdminConstants.ADMIN)}">
             <g:link value="Cancel" action="adminDashboard" class="btn btn-primary ">Cancel</g:link>
         </g:if>
         <g:elseif test="${(session?.user?.role?.roleName.equals(AdminConstants.QUALITY_LEAD) || session?.user?.role?.roleName.equals(AdminConstants.ADHOC))}">
             <g:link value="Cancel" action="qlDashboard" class="btn btn-primary ">Cancel</g:link>
         </g:elseif>
    </g:if>
     <g:if test="${params?.isReassignForm == "true"}">
         <button type="button" class="btn btn-primary cancelButton"
                     onclick="window.history.back();">Cancel</button>
     </g:if>
            <button value="Remove" id="saveUnassignUserButtonId" onclick="submitUnAssignUser()" type="button"
                onmouseover="showUnassignWarning()" onmouseout="hideUnassignWarning()" class="btn btn-primary ">Remove</button>
      </div>

    <div class="row">
    <div class="col-md-12" style="margin-top:16px;">
        <b><span class="warningMsg" id="unassignWarningMsgId"
                 style="margin-top: 15px;margin-left: 17em;margin-bottom: 40px;display: none"
                 style="color:#666666;">${AdminConstants.UN_ASSIGN_USER_WARNING_MSG}</span>
        </b></span>
    </div>
</div>
</form>