import 'package:flutter/material.dart';
import 'package:today_poor/core/theme/app_colors.dart';

/// 크루 멤버 한 명의 오늘 소비내역 업로드 상태.
class CrewMember {
  const CrewMember({
    required this.name,
    required this.hasUploaded,
    this.isMe = false,
  });

  /// 카드에 표시할 멤버 이름 (예: 세원).
  final String name;

  /// 오늘 소비내역을 업로드했는지 여부.
  final bool hasUploaded;

  /// 현재 로그인한 사용자 본인인지 여부.
  final bool isMe;

  CrewMember copyWith({bool? hasUploaded}) {
    return CrewMember(
      name: name,
      hasUploaded: hasUploaded ?? this.hasUploaded,
      isMe: isMe,
    );
  }
}

/// 백엔드 연동 전, 방 정보만으로 보여줄 임시 멤버 명단을 만든다.
///
/// 본인(두 번째 멤버, 인원이 1명이면 본인)만 미업로드 상태로 두어
/// "눌러서 업로드하기" 인터랙션을 확인할 수 있게 한다.
List<CrewMember> sampleCrewRoster(int memberCount) {
  const pool = ['세원', '예윤', '여원', '병윤', '민준'];
  final meIndex = memberCount >= 2 ? 1 : 0;

  return [
    for (var i = 0; i < memberCount; i++)
      CrewMember(
        name: pool[i % pool.length],
        hasUploaded: i != meIndex,
        isMe: i == meIndex,
      ),
  ];
}

/// 크루 멤버들의 오늘 업로드 현황을 보여주는 화면.
class CrewStatusPage extends StatefulWidget {
  const CrewStatusPage({
    super.key,
    required this.crewName,
    required this.capacity,
    required this.members,
    this.reportTime = '22:00',
  });

  final String crewName;
  final int capacity;
  final List<CrewMember> members;

  /// 리포트가 공개되는 시각 (예: 22:00).
  final String reportTime;

  @override
  State<CrewStatusPage> createState() => _CrewStatusPageState();
}

class _CrewStatusPageState extends State<CrewStatusPage> {
  late List<CrewMember> _members;

  @override
  void initState() {
    super.initState();
    _members = List<CrewMember>.from(widget.members);
  }

  void _uploadMine(int index) {
    setState(() {
      _members[index] = _members[index].copyWith(hasUploaded: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundTop, AppColors.background],
            stops: [0.08, 1],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 402),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _CrewHeader(),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 27),
                    child: Text(
                      '${widget.crewName}${_members.length}/${widget.capacity}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Text(
                      '${widget.reportTime}에 리포트가 공개됩니다.',
                      style: const TextStyle(
                        color: AppColors.reportHighlight,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Expanded(
                    child: ListView.separated(
                      key: const ValueKey('crew-member-list'),
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.fromLTRB(27, 0, 27, 40),
                      itemCount: _members.length,
                      itemBuilder: (context, index) {
                        return _MemberStatusCard(
                          member: _members[index],
                          onUpload: () => _uploadMine(index),
                        );
                      },
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CrewHeader extends StatelessWidget {
  const _CrewHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 22, 0),
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            Semantics(
              button: true,
              label: '뒤로',
              child: GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                behavior: HitTestBehavior.opaque,
                child: Image.asset(
                  'assets/images/today_poor_logo_horizontal.png',
                  width: 125,
                  height: 32,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            const Spacer(),
            Semantics(
              button: true,
              label: '프로필',
              child: GestureDetector(
                onTap: () {},
                child: Image.asset(
                  'assets/images/main_profile.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberStatusCard extends StatelessWidget {
  const _MemberStatusCard({required this.member, required this.onUpload});

  final CrewMember member;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 0,
            bottom: 0,
            child: Center(child: _MemberAvatar(name: member.name)),
          ),
          Center(
            child: _StatusContent(member: member, onUpload: onUpload),
          ),
        ],
      ),
    );
  }
}

class _StatusContent extends StatelessWidget {
  const _StatusContent({required this.member, required this.onUpload});

  final CrewMember member;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    if (member.hasUploaded) {
      return const Text(
        '업로드 완료!',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    if (!member.isMe) {
      return const Text(
        '아직 업로드되지 않았어요.',
        style: TextStyle(
          color: AppColors.textMuted,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return Semantics(
      key: const ValueKey('my-upload-action'),
      button: true,
      label: '내 소비내역 업로드',
      child: GestureDetector(
        onTap: onUpload,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/crew_upload.png',
              width: 38,
              height: 38,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
            const SizedBox(height: 4),
            const Text(
              '눌러서 업로드하기',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberAvatar extends StatelessWidget {
  const _MemberAvatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFE7C6B0),
            border: Border.all(color: const Color(0xFF9B846F)),
          ),
          padding: const EdgeInsets.all(1),
          child: ClipOval(
            child: Image.asset(
              'assets/images/main_profile.png',
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
