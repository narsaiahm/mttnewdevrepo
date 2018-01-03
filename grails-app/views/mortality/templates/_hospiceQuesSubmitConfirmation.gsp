<div class="modal fade" id="hospiceQuesSubmitDialog" role="dialog">
    <div class="modal-dialog">

        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" onclick="clearHospiceQues()">&times;</button>
                <h4 class="modal-title">Submit Review Form</h4>
            </div>

            <div class="modal-body">
                <div class="alert alert-warning">
                    <p style="font-size:13px;"><span
                            style="font-family:'Arial';font-weight:400;">Patients who were in a Hospice or receiving Hospice Care at home do not require further review.
                        Please confirm your response to this question before submitting.</span>
                    </p>
                </div>

            </div>

            <div class="modal-footer">
                <g:if
                        test="${session?.user?.email?.toString().toLowerCase().equals(mReviewForm?.lead?.email?.toString()?.toLowerCase())}">
                    <g:actionSubmit value="Submit"  action="submitFormThroughHospiceOption" class="btn btn-primary dropReadOnly"
                                    name="formSubmitInReview"
                                    onclick="return submitThroughHospiceOption()">Submit</g:actionSubmit>
                </g:if>
                    <button type="button" class="btn btn-primary cancelButton radio-inline" data-dismiss="modal" onclick="clearHospiceQues()">Cancel</button>

            </div>
        </div>

    </div>
</div>