@isTest
public class BI_PSPB_CommunityConstantTest {
	@isTest
	static void testConstants() {
		// Check if the error message constants are initialized correctly
		Assert.areEqual(
			System.Label.BI_PSP_ConsoleError,
			BI_PSPB_CommunityConstant.error,
			'Error constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_ErrorForUserName,
			BI_PSPB_CommunityConstant.errorWhileGetUsername,
			'Error for username constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_PatientEnrolleeError,
			BI_PSPB_CommunityConstant.errorWhileGetEnrolleeId,
			'Error for enrollee ID constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_AccountError,
			BI_PSPB_CommunityConstant.errorWhileGetAccountId,
			'Error for account ID constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_ErrorForCreateUserName,
			BI_PSPB_CommunityConstant.errorWhileCreatingUsername,
			'Error for creating username constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_ErrorForImage,
			BI_PSPB_CommunityConstant.errorWhileGetAvatar,
			'Error for avatar constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_ErrorForPostDeletion,
			BI_PSPB_CommunityConstant.errorWhileDeleting,
			'Error for deleting post constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_ErrorForPostSelection,
			BI_PSPB_CommunityConstant.errorWhileFetchingPost,
			'Error for fetching post constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_ErrorForPostCreation,
			BI_PSPB_CommunityConstant.errorWhileCreatingPost,
			'Error for creating post constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_ErrorForCommenting,
			BI_PSPB_CommunityConstant.errorWhileCreatingComment,
			'Error for creating comment constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_ErrorForComment,
			BI_PSPB_CommunityConstant.errorWhileGettingComment,
			'Error for getting comment constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_ErrorForUpdating,
			BI_PSPB_CommunityConstant.errorWhileEditingComment,
			'Error for editing comment constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_ErrorForDeleteComment,
			BI_PSPB_CommunityConstant.errorWhileDeletingComment,
			'Error for deleting comment constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_ErrorForReactPost,
			BI_PSPB_CommunityConstant.errorWhileReacting,
			'Error for reacting post constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_ErrorForDisplayReaction,
			BI_PSPB_CommunityConstant.errorWhileGetReactions,
			'Error for getting reactions constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_ErrorForUnreactPost,
			BI_PSPB_CommunityConstant.errorWhileUnreacting,
			'Error for unreacting post constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_ErrorForCheckingFollowStatus,
			BI_PSPB_CommunityConstant.errorWhileGetFollowStatus,
			'Error for getting follow status constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_ErrorForUnfollow,
			BI_PSPB_CommunityConstant.errorWhileUnfollowing,
			'Error for unfollowing constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_ErrorForFollowAccount,
			BI_PSPB_CommunityConstant.errorWhileFollowing,
			'Error for following account constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_ErrorForGettingFollower,
			BI_PSPB_CommunityConstant.errorWhileGettingFollowers,
			'Error for getting followers constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_ErrorForFollowUser,
			BI_PSPB_CommunityConstant.alreadyFollowing,
			'Error for already following constant does  match'
		);

		// Check the log severity constant
		Assert.areEqual(
			'ERROR',
			BI_PSPB_CommunityConstant.LOG_SEVERITY_ERROR,
			'Log severity constant does  match'
		);

		// Check the soft delete label
		Assert.areEqual(
			System.Label.BI_PSP_SoftDelete,
			BI_PSPB_CommunityConstant.softDelete,
			'Soft delete label constant does  match'
		);

		// Check the emoji reaction type labels
		Assert.areEqual(
			System.Label.BI_PSP_ThumbsUpNumber,
			BI_PSPB_CommunityConstant.thumbsUp,
			'Thumbs up label constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_Smile,
			BI_PSPB_CommunityConstant.smile,
			'Smile label constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_FoldedHandNumber,
			BI_PSPB_CommunityConstant.foldedHands,
			'Folded hands label constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_Heart,
			BI_PSPB_CommunityConstant.heart,
			'Heart label constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_ThinkingFaceNumber,
			BI_PSPB_CommunityConstant.thinkingFace,
			'Thinking face label constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_MessageForNoReactions,
			BI_PSPB_CommunityConstant.noReaction,
			'No reaction label constant does  match'
		);

		// Check the follow-related labels
		Assert.areEqual(
			System.Label.BI_PSP_Follower,
			BI_PSPB_CommunityConstant.follower,
			'Follower label constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_Follow,
			BI_PSPB_CommunityConstant.follow,
			'Follow label constant does  match'
		);
		Assert.areEqual(
			System.Label.BI_PSP_Following,
			BI_PSPB_CommunityConstant.following,
			'Following label constant does  match'
		);
	}
}