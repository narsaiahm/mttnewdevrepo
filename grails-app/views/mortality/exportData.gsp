<%@ page import="org.mountsinai.mortalitytriggersystem.MortalityConstants; org.mountsinai.mortalitytriggersystem.AdminConstants" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main" />
</head>
<div class="center">
    <label class="export">Selected Data</label>
</div>
<g:form action="exportData">
    <g:each in="${params}">
        <g:hiddenField name="${it.key}" value="${it.value}"></g:hiddenField>
    </g:each>
    <div class="col-md-12">
        <div class="form-group margin">
            Form Status:
            <span class="fontWeight-bold">
                <g:if test="${params.formStatus.equals(MortalityConstants.UNASSIGNED)}">
                    Unassigned & Incomplete
                </g:if>
                <g:elseif test="${params.formStatus.equals(MortalityConstants.SUBMITTED)}">
                    Complete & Submitted
                </g:elseif>
                <g:elseif test="${params.formStatus.equals(MortalityConstants.AMENDED)}">
                    Complete & Amended
                </g:elseif>
                <g:else>
                    ALL
                </g:else>
            </span>
            &nbsp;&nbsp;
        MSHS Hospital: <span class="fontWeight-bold">${facilityCode}</span>&nbsp;&nbsp;
        ${facilityCode.equals('ALL') ? 'MSHS' : facilityCode} Specialty: <span
                class="fontWeight-bold">${speciality}</span>&nbsp;&nbsp;
        Forms assigned to: <span class="fontWeight-bold">${params.assignedTo}</span>
        </div>

        <div class="row">

            <div class="col-md-12 margin_top_-10">
                <div class="table-responsive">
                    <table class="table table-striped table-bordered table-hover">
                        <thead>
                        <tr>
                            <th>Patient Name</th>
                            <th>Hospital</th>
                            <th>Discharge Date</th>
                            <th>Discharging Unit</th>
                            <th>Specialty </th>
                            <th>Assigned To</th>
                            <th>Days Since Death</th>
                            <th>Status Date/Time</th>
                            <th>Status</th>
                            <th>Status History</th>
                        </tr>
                        </thead>
                        <tbody>
                        <g:if test="${params.formStatus.equals(MortalityConstants.UNASSIGNED) || params.formStatus.equals(MortalityConstants.ALL)}">

                            <tr><td colspan="10" class="leftAlign"
                                style="background-color: lightgrey;font-weight: bold">Unassigned</td></tr>
                            <g:each in="${mortalityReviewList}" var="review">
                                <g:if test="${review.status.equals(MortalityConstants.UNASSIGNED)}">
                                    <tr>
                                        <td>${review.patientName}</td>
                                        <td>${review.facilityCode}</td>
                                        <td>${review.expiredDateTime}</td>
                                        <td>${review.dischargeUnit}</td>
                                        <td>${review.hospService}</td>
                                        <td></td>
                                        <td>${review.daysSinceDeath}</td>
                                        <td>${review.statusDateTime}</td>
                                        <td>${review.status}</td>
                                        <td style="text-align: left">${raw(review.statusHistoryStr)}</td>
                                    </tr>
                                </g:if>
                            </g:each>
                            <g:if test="${mortalityReviewList.grep { it -> it.status?.equals(MortalityConstants.UNASSIGNED) }.size() == 0}">
                                <tr><td colspan="10">No records found</td></tr>
                            </g:if>
                        </g:if>
                        <g:if test="${params.formStatus.equals(MortalityConstants.UNASSIGNED) || params.formStatus.equals(MortalityConstants.ALL)}">
                            <tr><td colspan="10" class="leftAlign"
                                    style="background-color: lightgrey;font-weight: bold">Incomplete</td></tr>
                            <g:each in="${mortalityReviewList}" var="review">
                                <g:if test="${review.status.equals(MortalityConstants.ASSIGNED) || review.status.equals(MortalityConstants.REASSIGNED) || review.status.equals(MortalityConstants.ACCEPTED) || review.status.equals(MortalityConstants.UPDATED)}">
                                    <tr>
                                        <td>${review.patientName}</td>
                                        <td>${review.facilityCode}</td>
                                        <td>${review.expiredDateTime}</td>
                                        <td>${review.dischargeUnit}</td>
                                        <td>${review.dischargingDivision}</td>
                                        <td>${review?.assignedTo}
                                            <g:if test="${review.assignedTo_role.equals(AdminConstants.QUALITY_LEAD)}">
                                                (Clinical Quality Lead)
                                            </g:if>
                                            <g:else>
                                                (Clinical Reviewer)
                                            </g:else>
                                        </td>
                                        <td>${review.daysSinceDeath}</td>
                                        <td>${review.statusDateTime}</td>
                                        <td>${review.status}</td>
                                        <td style="text-align: left">${raw(review.statusHistoryStr)}</td>
                                    </tr>
                                </g:if>
                            </g:each>
                            <g:if test="${mortalityReviewList.grep { it -> it.status?.equals(MortalityConstants.ASSIGNED) || it.status?.equals(MortalityConstants.REASSIGNED) || it.status?.equals(MortalityConstants.ACCEPTED) || it.status?.equals(MortalityConstants.UPDATED) }.size() == 0}">
                                <tr><td colspan="10">No records found</td></tr>
                            </g:if>
                        </g:if>
                        <g:if test="${params.formStatus.equals(MortalityConstants.SUBMITTED) || params.formStatus.equals(MortalityConstants.AMENDED) || params.formStatus.equals(MortalityConstants.ALL)}">
                            <tr><td colspan="10" class="leftAlign"
                                    style="background-color: lightgrey;font-weight: bold">Complete</td></tr>
                            <g:each in="${mortalityReviewList}" var="review">
                                <g:if test="${review.status.equals(MortalityConstants.SUBMITTED) || review.status.equals(MortalityConstants.AMENDED)}">
                                    <tr>
                                        <td>${review.patientName}</td>
                                        <td>${review.facilityCode}</td>
                                        <td>${review.expiredDateTime}</td>
                                        <td>${review.dischargeUnit}</td>
                                        <td>${review.dischargingDivision}</td>
                                        <td>${review.assignedTo}
                                            <g:if test="${review.assignedTo_role.equals(AdminConstants.QUALITY_LEAD)}">
                                                (Clinical Quality Lead)
                                            </g:if>
                                            <g:else>
                                                (Clinical Reviewer)
                                            </g:else>
                                        </td>
                                        <td>${review.daysSinceDeath}</td>
                                        <td>${review.statusDateTime}</td>
                                        <td>${review.status}</td>
                                        <td style="text-align: left">${raw(review.statusHistoryStr)}</td>
                                    </tr>
                                </g:if>
                            </g:each>
                            </tbody>
                            <g:if test="${mortalityReviewList.grep { it -> it.status?.equals(MortalityConstants.SUBMITTED) || it.status?.equals(MortalityConstants.AMENDED) }.size() == 0}">
                                <tr><td colspan="10">No records found</td></tr>
                            </g:if>
                        </g:if>
                    </table>
                </div>
            </div>
        </div>
        <g:link class="btn btn-primary" controller="mortality" action="adminDashboard">
            Cancel
        </g:link>
        <g:actionSubmit value="Export Data to Excel" action="exportSearchData"
                        onclick="this.form.action='${createLink(action: 'exportData')}';"
                        class="btn btn-primary"></g:actionSubmit>
    </div>

</g:form>