<%@ page import="org.mountsinai.mortalitytriggersystem.AdminConstants" %>
<!DOCTYPE html>
<html>

<head>
    <meta name="layout" content="main"/>
    <asset:javascript src="assignForm.js"/>
</head>

<body>
<form id="assignReviewForm">
    <div class="container">

        <g:if test="${flash.errorMsg}">
            <p  style="color: red;margin-left: 22%;">${flash.errorMsg}</p>
        </g:if>
        <div class="row">
            <div class="col-md-6">
                <div>
                    <p><span class="title">Patient Information</span>
                    </p>
                </div>

                <div class="part1">
                    <table class="personalInfoTable">
                        <tr>
                            <td><span>Patient Name:</span>
                                <span><b>${reviewinfo?.patientName}</b></span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span>MRN:</span>
                                <span><b>${reviewinfo?.mrn}</b></span>
                            </td>
                        </tr>
                        <tr><td>
                            <span>
                                Hospital:</span>
                            <span><b>${reviewinfo?.reviewFacilityCode}</b></span></td>
                        </tr>

                    </table>
                </div>
            </div>
            <g:if test="${assignedToUser?.name}">
                <div class="col-md-6">
                    <div>
                        <p>&nbsp;
                        </p>
                    </div>

                    <div class="part1">
                        <table class="personalInfoTable">
                            <tr>
                                <td><span>Assigned To:</span>
                                    <span><b>${assignedToUser?.name}
                                        <g:if test="${assignedToUser?.role?.roleName.equals(AdminConstants.QUALITY_LEAD)}">
                                            (Clinical Quality Lead)
                                        </g:if>
                                        <g:elseif test="${assignedToUser?.role?.roleName.equals(AdminConstants.ADHOC)}">
                                            (Clinical Reviewer)
                                        </g:elseif>
                                    </b></span>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <span>&nbsp;</span>
                                </td>
                            </tr>
                            <tr><td>
                                <span>&nbsp;</span>
                            </tr>

                        </table>
                    </div>

                </div>
            </g:if>
        </div>

        <div class="row">
            <div class="col-md-6">
                <h4>Assign Form to a Clinical Quality Lead</h4>
                <table class="table table-bordered leftAlign">
                    <thead>
                    <tr>
                        <th>
                            <g:if test="${session?.user?.role?.roleName.equals(AdminConstants.ADMIN)}">
                                Clinical Quality Lead
                            </g:if>
                            <g:elseif
                                    test="${(session?.user?.role?.roleName.equals(AdminConstants.QUALITY_LEAD) || session?.user?.role?.roleName.equals(AdminConstants.ADHOC))}">
                                Clinical Quality Lead
                            </g:elseif>
                        </th>
                        <th>Specialty</th>

                    </tr>
                    </thead>
                    <tbody>
                    <g:each in="${allLeadsList}" var="lead">
                        <tr>
                            <td>
                                <label class="radio-inline control-label">
                                    <input type="radio" name="lead" value="${lead.id}"
                                           data-leadId="${lead.id}" data-leadName="${lead.name}" onclick="clearReview()"/>${lead.name}
                                </label>
                            </td>
                            <td>
                                ${lead?.speciality?.specialityName}
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>

            <div class="col-md-6">
                <h4>Assign Form to Clinical Reviewer</h4>

                <div class="form-group col-md-8">
                    <div class="col-sm-10">
                        <label class="control-label">Search for Clinical Reviewer:</label>
                        <input class="form-control " name="reviewer" id="reviewer"
                               onfocus="removeErrorClass()">
                    </div>

                    <div class="col-sm-2">

                        <button id="searchReviewer" onclick="searchReviewerList()" type="button"
                                style="margin-top: 18px;margin-left: -25px;"
                                class="btn btn-primary "><span class="glyphicon glyphicon-search"></span></button>
                    </div>
                </div>

                <div class="form-group col-md-8" style="margin-left: 15px;">
                    <label class="control-label">Employee Name:</label>
                    <input class="form-control " type="text" value="" readonly="true" id="empName">
                </div>


                <div class="form-group col-md-8" style="margin-left: 15px;">
                    <label class="control-label">Employee Email:</label>
                    <input class="form-control " type="text" value="" readonly="true" id="empEmail">
                </div>


                <div class="form-group col-md-8" style="margin-left: 15px;">
                    <p id="empError" style="color: red;"></p>
                </div>
            </div>

        </div>

        <div class="row">
            <div class="col-md-4" style = "width: 37.333333%;">
                <g:if test="${session?.user?.role?.roleName.equals(AdminConstants.ADMIN)}">
                    <g:link action="assignEmplToQl"
                            class="assignEmplToQL" params="[isReassignForm:true]">Assign MSHS Employees to Clinical Quality Lead</g:link>
                </g:if>

            </div>

            <div class="col-md-6">
                <g:if test="${reviewinfo?.isReviewForm == "false"}">
                     <g:if test="${(session?.user?.role?.roleName.equals(AdminConstants.ADMIN))}">
                        <g:link class="btn btn-primary cancelButton radio-inline" action="adminDashboard" >Cancel</g:link>
                    </g:if>
                    <g:elseif test="${(session?.user?.role?.roleName.equals(AdminConstants.QUALITY_LEAD) || session?.user?.role?.roleName.equals(AdminConstants.ADHOC))}">
                        <g:link class="btn btn-primary cancelButton radio-inline" action="qlDashboard" >Cancel</g:link>
                    </g:elseif>
                </g:if>
                <g:if test="${reviewinfo?.isReviewForm == "true"}">

                    <button type="button" class="btn btn-primary cancelButton"
                            onclick="window.history.back();">Cancel</button>
                </g:if>
               <g:actionSubmit value="Submit" id="submitReviewLead" onclick="return assignedUserNameValidation()"
                                action="assignLeadReviewer"
                                class="btn btn-primary ">Submit</g:actionSubmit>
            </div>
        </div>

    </div>

    <div>
        %{--  <g:if test="${session?.user?.role?.roleName.equals(AdminConstants.ADMIN)}">
          <g:link controller="admin" action="assignEmplToQL"
                  class="assignEmplToQL">Assign MSHS Employees to Quality Lead</g:link>
          </g:if>--}%
        <g:hiddenField name="assignedUser" id="assignedUser" value=""></g:hiddenField>
        <g:hiddenField name="reviewId" id="reviewId" value="${reviewinfo?.reviewId}"></g:hiddenField>
        <g:hiddenField name="status" id="status" value="${reviewinfo?.status}"></g:hiddenField>
        <g:hiddenField name="patientName" id="patientName" value="${reviewinfo?.patientName}"></g:hiddenField>
        <g:hiddenField name="leadId" id="leadId" value="${reviewinfo?.lead}"></g:hiddenField>
        <g:hiddenField name="mrn" id="mrn" value="${reviewinfo?.mrn}"></g:hiddenField>
        <g:hiddenField name="userRole" id="userRole" value="${session?.user?.role?.roleName}"></g:hiddenField>
        <g:hiddenField name="role" id="role" value="${reviewinfo?.role}"></g:hiddenField>
        <g:hiddenField name="expiredDateTime" id="expiredDateTime" value="${reviewinfo?.expiredDateTime}"></g:hiddenField>
        <g:hiddenField name="isReviewForm" id="isReviewForm" value="${reviewinfo?.isReviewForm}"></g:hiddenField>
        <g:hiddenField name="userEmailId" id="userEmailId" value=""></g:hiddenField>
        <g:hiddenField name="assignedUserName" id="assignedUserName" value="${assignedToUser?.name}"></g:hiddenField>


        %{--<button type="submit" id="saveAssignButtonId" class="btn btn-primary"
                 onclick="assignFormReviewer(${reviewinfo.reviewId}, '${reviewinfo.status}', '${reviewinfo.patientName}', ${reviewinfo.mrn});">Submit</button>--}%
    </div>

    <div id="employeeResult"></div>
</form>
</body>
</html>