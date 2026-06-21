import 'package:flutter/material.dart';
import 'package:today_poor/core/theme/app_colors.dart';
import 'package:today_poor/features/crew/presentation/crew_status_page.dart';
import 'package:today_poor/features/home/presentation/widgets/create_room_dialog.dart';

enum HomeViewState { empty, rooms }

/// 사용자가 참여한 방을 보여주는 메인 화면.
///
/// 현재는 [HomeViewState.empty]만 구현되어 있으며, 방 목록은 백엔드 연동
/// 시점에 동일한 페이지의 [HomeViewState.rooms] 영역에 추가한다.
class HomePage extends StatefulWidget {
  const HomePage({super.key, this.viewState = HomeViewState.empty});

  final HomeViewState viewState;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeViewState _viewState;
  final List<_RoomItem> _rooms = [];

  @override
  void initState() {
    super.initState();
    _viewState = widget.viewState;
  }

  Future<void> _openCreateRoomDialog() async {
    final result = await showDialog<CreateRoomResult>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (_) => const CreateRoomDialog(),
    );

    if (result == null || !mounted) return;

    setState(() {
      _rooms.insert(
        0,
        _RoomItem(name: result.name, memberCount: 1, capacity: result.capacity),
      );
      _viewState = HomeViewState.rooms;
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
                children: [
                  _HomeHeader(onAddRoom: _openCreateRoomDialog),
                  Expanded(
                    child: switch (_viewState) {
                      HomeViewState.empty => _EmptyRoomsView(
                        onAddRoom: _openCreateRoomDialog,
                      ),
                      HomeViewState.rooms => _RoomsView(rooms: _rooms),
                    },
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

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.onAddRoom});

  final VoidCallback onAddRoom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 22, 0),
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            Image.asset(
              'assets/images/today_poor_logo_horizontal.png',
              width: 125,
              height: 32,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
            const Spacer(),
            _AddRoomButton(
              size: 36,
              onPressed: onAddRoom,
              semanticLabel: '방 추가',
            ),
            const SizedBox(width: 10),
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

class _EmptyRoomsView extends StatelessWidget {
  const _EmptyRoomsView({required this.onAddRoom});

  final VoidCallback onAddRoom;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.translate(
        offset: const Offset(0, -18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _AddRoomButton(
              size: 72,
              onPressed: onAddRoom,
              semanticLabel: '첫 방 추가',
            ),
            const SizedBox(height: 24),
            const Text(
              '참여 중인 방이 없어요.\n아이콘을 눌러 방을 추가해주세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddRoomButton extends StatelessWidget {
  const _AddRoomButton({
    required this.size,
    required this.onPressed,
    required this.semanticLabel,
  });

  final double size;
  final VoidCallback onPressed;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onPressed,
        behavior: HitTestBehavior.opaque,
        child: SizedBox.square(
          dimension: size,
          child: Image.asset(
            'assets/images/main_add.png',
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}

class _RoomsView extends StatefulWidget {
  const _RoomsView({required this.rooms});

  final List<_RoomItem> rooms;

  @override
  State<_RoomsView> createState() => _RoomsViewState();
}

class _RoomsViewState extends State<_RoomsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _openCrewStatus(BuildContext context, _RoomItem room) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CrewStatusPage(
          crewName: room.name,
          capacity: room.capacity,
          members: sampleCrewRoster(room.memberCount),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 72),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 27),
            child: _ReportCard(),
          ),
          const SizedBox(height: 38),
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              child: ListView.separated(
                key: const ValueKey('room-list'),
                controller: _scrollController,
                primary: false,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(27, 0, 27, 40),
                itemCount: widget.rooms.length,
                itemBuilder: (context, index) {
                  final room = widget.rooms[index];
                  return _RoomCard(
                    room: room,
                    onTap: () => _openCrewStatus(context, room),
                  );
                },
                separatorBuilder: (_, _) => const SizedBox(height: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 17),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.savings_outlined,
                size: 18,
                color: AppColors.brandStroke,
              ),
              SizedBox(width: 8),
              Text(
                '나만의 소비내역 리포트 보기',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Spacer(),
          Center(
            child: Text(
              '오늘의 소비내역을 올려주세요!',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({required this.room, required this.onTap});

  final _RoomItem room;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 130,
        padding: const EdgeInsets.fromLTRB(20, 22, 17, 10),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${room.name} ${room.memberCount}/${room.capacity}',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var index = 0; index < room.capacity; index++) ...[
                  _MemberAvatar(
                    isOccupied: index < room.memberCount,
                    index: index,
                  ),
                  if (index != room.capacity - 1) const SizedBox(width: 7),
                ],
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }
}

class _MemberAvatar extends StatelessWidget {
  const _MemberAvatar({required this.isOccupied, required this.index});

  final bool isOccupied;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (!isOccupied) {
      return const CircleAvatar(radius: 15, backgroundColor: Color(0xFFD9D9D9));
    }

    return Opacity(
      opacity: index.isEven ? 1 : 0.72,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index.isEven
              ? const Color(0xFFE7C6B0)
              : const Color(0xFFDDE5E8),
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
    );
  }
}

class _RoomItem {
  const _RoomItem({
    required this.name,
    required this.memberCount,
    required this.capacity,
  });

  final String name;
  final int memberCount;
  final int capacity;
}
