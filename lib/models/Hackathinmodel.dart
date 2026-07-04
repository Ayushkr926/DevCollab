import 'package:flutter/material.dart';

class Hackathon {
  final String id;
  final String title;
  final String tagline;
  final String description;


  final Color? accentColor;
  // Organization
  final String organizer;
  final String organizerLogo;
  final String organizerWebsite;

  // Banner & Media
  final String bannerImage;
  final List<String> galleryImages;
  final String promoVideo;

  // Theme & Tech
  final List<String> themes;
  final List<String> technologies;

  // Location
  final bool isOnline;
  final String venue;
  final String city;
  final String state;
  final String country;
  final String googleMapLink;

  // Timeline
  final DateTime registrationStart;
  final DateTime registrationEnd;
  final DateTime hackathonStart;
  final DateTime hackathonEnd;
  final DateTime resultDate;

  // Registration
  final bool registrationOpen;
  final bool requiresApproval;
  final double registrationFee;
  final int maxParticipants;
  final int minTeamSize;
  final int maxTeamSize;

  // Prize
  final String totalPrizePool;
  final List<Prize> prizes;

  // People
  final List<Person> judges;
  final List<Person> mentors;

  // Sponsors
  final List<Sponsor> sponsors;

  // Content
  final List<FAQ> faqs;
  final List<ScheduleItem> schedule;
  final List<Track> tracks;
  final List<Resource> resources;

  // Social & Contact
  final String discordLink;
  final String whatsappLink;
  final String linkedinLink;
  final String instagramLink;
  final String email;
  final String phone;

  // Stats
  final int registeredTeams;
  final int registeredParticipants;
  final int views;
  final double rating;

  // Rules & Eligibility
  final String eligibility;
  final List<String> rules;

  // Certificates
  final bool participationCertificate;
  final bool winnerCertificate;

  // Misc
  final bool featured;
  final bool bookmarked;
  final DateTime createdAt;
  final DateTime updatedAt;

  Hackathon({
    required this.id,
    required this.title,
    required this.tagline,
    required this.description,
    required this.organizer,
    required this.organizerLogo,
    required this.organizerWebsite,
    required this.bannerImage,
    required this.galleryImages,
    required this.promoVideo,
    required this.themes,
    required this.technologies,
    required this.isOnline,
    this.accentColor,
    required this.venue,
    required this.city,
    required this.state,
    required this.country,
    required this.googleMapLink,
    required this.registrationStart,
    required this.registrationEnd,
    required this.hackathonStart,
    required this.hackathonEnd,
    required this.resultDate,
    required this.registrationOpen,
    required this.requiresApproval,
    required this.registrationFee,
    required this.maxParticipants,
    required this.minTeamSize,
    required this.maxTeamSize,
    required this.totalPrizePool,
    required this.prizes,
    required this.judges,
    required this.mentors,
    required this.sponsors,
    required this.faqs,
    required this.schedule,
    required this.tracks,
    required this.resources,
    required this.discordLink,
    required this.whatsappLink,
    required this.linkedinLink,
    required this.instagramLink,
    required this.email,
    required this.phone,
    required this.registeredTeams,
    required this.registeredParticipants,
    required this.views,
    required this.rating,
    required this.eligibility,
    required this.rules,
    required this.participationCertificate,
    required this.winnerCertificate,
    required this.featured,
    required this.bookmarked,
    required this.createdAt,
    required this.updatedAt,
  });

  // Computed Properties
  bool get isUpcoming => hackathonStart.isAfter(DateTime.now());
  bool get isOngoing => hackathonStart.isBefore(DateTime.now()) && hackathonEnd.isAfter(DateTime.now());
  bool get isPast => hackathonEnd.isBefore(DateTime.now());

  String get duration {
    final days = hackathonEnd.difference(hackathonStart).inDays;
    return "$days days";
  }

  String get registrationStatus {
    if (!registrationOpen) return "Closed";
    if (DateTime.now().isAfter(registrationEnd)) return "Registration Closed";
    return "Open";
  }

  // CopyWith method (Very Important for Provider & State Management)
  Hackathon copyWith({
    bool? bookmarked,
    // Add other fields if needed in future
  }) {
    return Hackathon(
      id: id,
      title: title,
      tagline: tagline,
      description: description,
      organizer: organizer,
      organizerLogo: organizerLogo,
      organizerWebsite: organizerWebsite,
      bannerImage: bannerImage,
      galleryImages: galleryImages,
      promoVideo: promoVideo,
      themes: themes,
      technologies: technologies,
      isOnline: isOnline,
      venue: venue,
      city: city,
      state: state,
      country: country,
      googleMapLink: googleMapLink,
      registrationStart: registrationStart,
      registrationEnd: registrationEnd,
      hackathonStart: hackathonStart,
      hackathonEnd: hackathonEnd,
      resultDate: resultDate,
      registrationOpen: registrationOpen,
      requiresApproval: requiresApproval,
      registrationFee: registrationFee,
      maxParticipants: maxParticipants,
      minTeamSize: minTeamSize,
      maxTeamSize: maxTeamSize,
      totalPrizePool: totalPrizePool,
      prizes: prizes,
      judges: judges,
      mentors: mentors,
      sponsors: sponsors,
      faqs: faqs,
      schedule: schedule,
      tracks: tracks,
      resources: resources,
      discordLink: discordLink,
      whatsappLink: whatsappLink,
      linkedinLink: linkedinLink,
      instagramLink: instagramLink,
      email: email,
      phone: phone,
      registeredTeams: registeredTeams,
      registeredParticipants: registeredParticipants,
      views: views,
      rating: rating,
      eligibility: eligibility,
      rules: rules,
      participationCertificate: participationCertificate,
      winnerCertificate: winnerCertificate,
      featured: featured,
      bookmarked: bookmarked ?? this.bookmarked,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Demo Data
  static List<Hackathon> getDemoHackathons() {
    return [
      Hackathon(
        id: "1",
        title: "HackIndia 2026",
        tagline: "Build the Future of India",
        description: "India's biggest student hackathon with exciting challenges.",
        organizer: "Microsoft | Google | NASSCOM",
        organizerLogo: "https://example.com/microsoft.png",
        organizerWebsite: "https://hackindia.com",
        bannerImage: "https://picsum.photos/id/1015/800/400",
        galleryImages: [],
        promoVideo: "",
        themes: ["AI/ML", "Web3", "Sustainability", "HealthTech"],
        technologies: ["Flutter", "Python", "TensorFlow"],
        isOnline: false,
        venue: "Bangalore International Exhibition Centre",
        city: "Bangalore",
        state: "Karnataka",
        country: "India",
        googleMapLink: "",
        registrationStart: DateTime.now().subtract(const Duration(days: 10)),
        registrationEnd: DateTime.now().add(const Duration(days: 12)),
        hackathonStart: DateTime.now().add(const Duration(days: 25)),
        hackathonEnd: DateTime.now().add(const Duration(days: 27)),
        resultDate: DateTime.now().add(const Duration(days: 30)),
        registrationOpen: true,
        requiresApproval: false,
        registrationFee: 0,
        maxParticipants: 5000,
        minTeamSize: 2,
        maxTeamSize: 4,
        totalPrizePool: "₹25,00,000",
        prizes: [
          Prize(position: "1st", amount: "₹10,00,000", description: "Grand Prize"),
          Prize(position: "2nd", amount: "₹6,00,000", description: "Runner Up"),
        ],
        judges: [],
        mentors: [],
        sponsors: [],
        faqs: [],
        schedule: [],
        tracks: [],
        resources: [],
        discordLink: "",
        whatsappLink: "",
        linkedinLink: "",
        instagramLink: "",
        email: "contact@hackindia.com",
        phone: "+91 98765 43210",
        registeredTeams: 1240,
        registeredParticipants: 4520,
        views: 45200,
        rating: 4.8,
        eligibility: "Open to all college students in India",
        rules: ["Team of 2-4 members", "Original work only"],
        participationCertificate: true,
        winnerCertificate: true,
        featured: true,
        bookmarked: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      // Add more demo items as needed...
    ];
  }
}

// Supporting Models (Cleaned)
class Prize {
  final String position;
  final String amount;
  final String description;

  Prize({required this.position, required this.amount, required this.description});
}

class Person {
  final String name;
  final String designation;
  final String company;
  final String image;
  final String linkedin;

  Person({
    required this.name,
    required this.designation,
    required this.company,
    required this.image,
    required this.linkedin,
  });
}

class Sponsor {
  final String name;
  final String logo;
  final String website;

  Sponsor({required this.name, required this.logo, required this.website});
}

class FAQ {
  final String question;
  final String answer;

  FAQ({required this.question, required this.answer});
}

class ScheduleItem {
  final String title;
  final DateTime dateTime;
  final String description;

  ScheduleItem({required this.title, required this.dateTime, required this.description});
}

class Track {
  final String title;
  final String description;
  final String icon;

  Track({required this.title, required this.description, required this.icon});
}

class Resource {
  final String title;
  final String url;
  final String type;

  Resource({required this.title, required this.url, required this.type});
}