import Foundation
import WebUI

struct SchengenTracker: Document {
  var path: String? { "tools/schengen-tracker" }

  var metadata: Metadata {
    Metadata(from: Application().metadata, title: "Schengen 90/180 Tracker - Mac Long Tools")
  }

  var body: some Markup {
    Layout(
      path: "tools/schengen-tracker",
      title: "Schengen 90/180 Tracker - Mac Long Tools",
      description:
        "Track Schengen area visits and monitor 90/180 day rule compliance with visual timeline calculations.",
      breadcrumbs: [
        Breadcrumb(title: "Mac Long", url: "/"),
        Breadcrumb(title: "Tools", url: "/tools"),
        Breadcrumb(title: "Schengen Tracker", url: "/tools/schengen-tracker"),
      ]
    ) {
      LayoutHeader(
        breadcrumbs: [
          Breadcrumb(title: "Mac Long", url: "/"),
          Breadcrumb(title: "Tools", url: "/tools"),
          Breadcrumb(title: "Schengen Tracker", url: "/tools/schengen-tracker"),
        ],
        toolControls: {
          [
            Button(
              onClick: "showShare()",
              classes: [
                "p-2", "text-zinc-500", "hover:text-zinc-700", "dark:text-zinc-400",
                "dark:hover:text-zinc-200", "rounded-lg", "hover:bg-zinc-100",
                "dark:hover:bg-zinc-700", "transition-colors", "cursor-pointer",
              ],
              label: "Share data"
            ) {
              Icon(name: "share-2", classes: ["w-5", "h-5"])
            },

            Button(
              onClick: "showInfo()",
              classes: [
                "p-2", "text-zinc-500", "hover:text-zinc-700", "dark:text-zinc-400",
                "dark:hover:text-zinc-200", "rounded-lg", "hover:bg-zinc-100",
                "dark:hover:bg-zinc-700", "transition-colors", "cursor-pointer",
              ],
              label: "Information"
            ) {
              Icon(name: "info", classes: ["w-5", "h-5"])
            },
          ]
        },
        emoji: "✈️"
      )

      Stack(classes: ["max-w-4xl", "mx-auto"]) {
        // Shared data banner
        Stack(
          id: "shared-banner",
          classes: [
            "mb-6", "p-4", "bg-orange-50", "dark:bg-orange-900/20", "border",
            "border-orange-200", "dark:border-orange-800", "rounded-lg", "hidden",
          ]
        ) {
          Stack(classes: ["flex", "items-center", "justify-between"]) {
            Stack(classes: ["flex", "items-center", "gap-2"]) {
              Icon(name: "share-2", classes: ["text-orange-600", "dark:text-orange-400", "w-5", "h-5"])
              Text(
                "Viewing shared data - changes won't be saved automatically",
                classes: [
                  "text-orange-800", "dark:text-orange-200", "font-medium",
                ]
              )
            }
            Button(
              onClick: "saveToMyData()",
              classes: [
                "bg-orange-600", "hover:bg-orange-700", "dark:bg-orange-500",
                "dark:hover:bg-orange-600", "text-white", "px-4", "py-2",
                "rounded-lg", "transition-colors", "text-sm", "font-medium",
              ]
            ) { Text("Save to My Data") }
          }
        }

        // Error Display
        Stack(
          id: "error-banner",
          classes: [
            "mb-6", "p-4", "bg-red-50", "dark:bg-red-900/20", "border",
            "border-red-200", "dark:border-red-800", "rounded-lg", "hidden",
          ]
        ) {
          Text("", id: "error-text", classes: ["text-red-800", "dark:text-red-200", "text-sm"])
        }

        // Current Status
        Stack(classes: ["grid", "md:grid-cols-2", "gap-6", "mb-6"]) {
          Stack(classes: [
            "bg-white", "dark:bg-zinc-800", "border", "border-zinc-200", "dark:border-zinc-700", "p-6", "rounded-lg",
          ]) {
            Heading(.title, "Days Used", classes: ["text-lg", "font-semibold", "mb-2"])
            Text("0/90", id: "days-used", classes: ["text-4xl", "font-bold", "text-teal-600", "dark:text-teal-400"])
          }

          Stack(
            id: "days-remaining-card",
            classes: [
              "bg-white", "dark:bg-zinc-800", "border", "p-6", "rounded-lg", "border-green-200",
              "dark:border-green-800",
            ]
          ) {
            Heading(.title, "Days Remaining", classes: ["text-lg", "font-semibold", "mb-2"])
            Stack(classes: ["flex", "items-baseline", "gap-2"]) {
              Text(
                "90",
                id: "days-remaining",
                classes: ["text-4xl", "font-bold", "text-green-600", "dark:text-green-400"]
              )
              Stack(id: "days-after-planned-container", classes: ["flex", "items-baseline", "gap-1", "ml-1", "hidden"]) {
                Text(
                  "",
                  id: "days-after-planned",
                  classes: ["text-4xl", "font-bold", "text-green-600", "dark:text-green-400", "opacity-60"]
                )
                Stack(classes: ["relative", "group"]) {
                  Icon(
                    name: "info",
                    classes: ["w-4", "h-4", "text-green-600", "dark:text-green-400", "opacity-60", "cursor-help"]
                  )
                  Stack(classes: [
                    "absolute", "bottom-full", "left-1/2", "transform", "-translate-x-1/2", "mb-2",
                    "bg-zinc-900", "dark:bg-zinc-700", "text-white", "text-xs", "rounded", "py-1", "px-2",
                    "whitespace-nowrap", "opacity-0", "group-hover:opacity-100", "transition-opacity",
                    "pointer-events-none", "z-10"
                  ]) {
                    Text("After planned trips")
                  }
                }
              }
            }
          }
        }

        // Next Reset
        Stack(classes: [
          "bg-white", "dark:bg-zinc-800", "p-6", "rounded-lg", "border", "border-zinc-200", "dark:border-zinc-700",
          "mb-6", "flex", "flex-col"
        ]) {
          Heading(.title, "Next Reset Date", classes: ["text-lg", "font-semibold", "mb-2"])
          Text("No visits yet", id: "next-reset", classes: ["text-2xl", "mb-4"])
          Text(
            "Your allowance will begin restoring on this date as your earliest visit falls outside the 180-day rolling window.",
            id: "reset-description",
            classes: ["text-sm", "text-zinc-600", "dark:text-zinc-400", "hidden"]
          )
          Text("", id: "reset-days", classes: ["text-sm", "text-zinc-500", "dark:text-zinc-500", "mt-2", "hidden"])
        }

        // Add New Visit
        Stack(classes: [
          "bg-white", "dark:bg-zinc-800", "p-6", "rounded-lg", "border", "border-zinc-200", "dark:border-zinc-700",
          "mb-6",
        ]) {
          Heading(.title, "Add New Visit", classes: ["text-xl", "font-semibold", "mb-4"])
          Stack(classes: ["grid", "md:grid-cols-2", "gap-4", "mb-4"]) {
            Stack {
              Text("Entry Date", classes: ["block", "text-sm", "font-medium", "mb-2"])
              MarkupString(
                content: """
                      <input type="date" id="entry-date" class="w-full px-3 py-3 border border-zinc-300 dark:border-zinc-600 bg-white dark:bg-gray-700 text-zinc-900 dark:text-zinc-100 rounded-lg focus:ring-2 focus:ring-teal-500 focus:border-teal-500 dark:focus:ring-teal-400 dark:focus:border-teal-400">
                  """
              )
            }
            Stack {
              Text("Exit Date", classes: ["block", "text-sm", "font-medium", "mb-2"])
              MarkupString(
                content: """
                      <input type="date" id="exit-date" class="w-full px-3 py-3 border border-zinc-300 dark:border-zinc-600 bg-white dark:bg-gray-700 text-zinc-900 dark:text-zinc-100 rounded-lg focus:ring-2 focus:ring-teal-500 focus:border-teal-500 dark:focus:ring-teal-400 dark:focus:border-teal-400">
                  """
              )
            }
          }
          Stack(classes: ["mb-4"]) {
            Text("Location", classes: ["block", "text-sm", "font-medium", "mb-2"])
            Input(
              name: "location",
              type: .text,
              placeholder: "e.g., Paris, France",
              id: "location",
              classes: [
                "w-full", "px-3", "py-3", "border", "border-zinc-300",
                "dark:border-zinc-600", "bg-white", "dark:bg-gray-700",
                "rounded-lg", "focus:ring-2", "focus:ring-teal-500",
                "focus:border-teal-500", "dark:focus:ring-teal-400", "dark:focus:border-teal-400",
              ]
            )
          }
          Button(
            onClick: "addVisit()",
            id: "add-visit-btn",
            classes: [
              "w-full", "bg-gray-400", "dark:bg-zinc-600", "text-white", "p-3",
              "rounded-lg", "disabled:cursor-not-allowed", "flex", "items-center",
              "justify-center", "gap-2", "font-medium", "transition-colors"
            ]
          ) {
            Icon(name: "plus", classes: ["w-5", "h-5"])
            Text("Add Visit")
          }
        }

        // Visit History
        Stack {
          Heading(.title, "Previous Visits (0)", id: "visits-header", classes: ["text-xl", "font-semibold", "mb-4"])
          Stack(
            id: "empty-state",
            classes: [
              "text-center", "py-12", "bg-white", "dark:bg-zinc-800",
              "border", "border-zinc-200", "dark:border-zinc-700", "rounded-lg",
            ]
          ) {
            Icon(name: "calendar", classes: ["w-12", "h-12", "mx-auto", "mb-4", "opacity-50"])
            Text(
              "No visits recorded yet. Add your first visit above.",
              classes: ["text-balance", "max-w-xs", "mx-auto"]
            )
          }
          Stack(id: "visits-list", classes: ["space-y-3", "hidden"])
        }
      }

      InfoModal(
        id: "info-modal",
        title: "How the Schengen 90/180 Rule Works",
        onClose: "hideInfo()",
        content: """
          <p><strong>The Rule:</strong> You can stay up to 90 days within any 180-day period in the Schengen area. This is a rolling window that moves with each day.</p>
          <p>The tracker calculates your usage based on visits within the last 180 days from today. Your allowance resets gradually as old visits fall outside the 180-day window.</p>
          <p><strong>Next Reset:</strong> Shows when your earliest visit will fall outside the 180-day window, beginning to restore your allowance.</p>
          <p><strong>Sharing:</strong> Generate a secure link to share your visit history with family, friends, or advisors. The link contains only your travel dates and locations.</p>
        """
      )

      ShareModal(
        id: "share-modal",
        onClose: "hideShare()"
      )

      Script(content: {
        """
        // Schengen Tracker App
        (function() {
            let state = {
                visits: [],
                shareUrl: '',
                copied: false,
                isSharedData: false,
                error: '',
                showInfoModal: false,
                showShareModal: false,
                daysUsed: 0,
                daysRemaining: 90,
                nextResetDate: null
            };

            // Global functions
            window.showInfo = function() {
                state.showInfoModal = true;
                const modal = document.getElementById('info-modal');
                if (modal) modal.classList.remove('hidden');
            };

            window.hideInfo = function() {
                state.showInfoModal = false;
                const modal = document.getElementById('info-modal');
                if (modal) modal.classList.add('hidden');
            };

            window.showShare = function() {
                state.showShareModal = true;
                const modal = document.getElementById('share-modal');
                if (modal) modal.classList.remove('hidden');
            };

            window.hideShare = function() {
                state.showShareModal = false;
                const modal = document.getElementById('share-modal');
                if (modal) modal.classList.add('hidden');
            };

            window.addVisit = function() {
                const entryDate = document.getElementById('entry-date').value;
                const exitDate = document.getElementById('exit-date').value;
                const location = document.getElementById('location').value;

                if (!entryDate || !exitDate) return;

                const entry = new Date(entryDate);
                const exit = new Date(exitDate);

                if (entry > exit) {
                    showError('Entry date must be before exit date');
                    return;
                }

                const newVisit = {
                    id: Date.now(),
                    entry: entryDate,
                    exit: exitDate,
                    location: location.trim() || 'Schengen Area',
                    days: Math.ceil((exit - entry) / (1000 * 60 * 60 * 24)) + 1,
                    isEditing: false
                };

                state.visits.push(newVisit);
                state.visits.sort((a, b) => new Date(a.entry) - new Date(b.entry));
                saveVisits();
                updateCalculations();
                updateFutureTripDisplay();

                // Clear form
                document.getElementById('entry-date').value = '';
                document.getElementById('exit-date').value = '';
                document.getElementById('location').value = '';

                if (state.isSharedData) {
                    state.isSharedData = false;
                    updateSharedBanner();
                }

                renderVisits();
                updateAddButton();
            };

            window.removeVisit = function(id) {
                state.visits = state.visits.filter(visit => visit.id !== id);
                saveVisits();
                updateCalculations();
                updateFutureTripDisplay();
                
                if (state.isSharedData) {
                    state.isSharedData = false;
                    updateSharedBanner();
                }
                
                renderVisits();
                updateFutureTripDisplay();
            };

            window.startEdit = function(id) {
                const visit = state.visits.find(v => v.id === id);
                if (visit) {
                    visit._backup = { entry: visit.entry, exit: visit.exit, location: visit.location };
                    visit.isEditing = true;
                    renderVisits();
                }
            };

            window.cancelEdit = function(id) {
                const visit = state.visits.find(v => v.id === id);
                if (visit && visit._backup) {
                    visit.entry = visit._backup.entry;
                    visit.exit = visit._backup.exit;
                    visit.location = visit._backup.location;
                    delete visit._backup;
                    visit.isEditing = false;
                    renderVisits();
                }
            };

            window.saveEdit = function(id) {
                const visit = state.visits.find(v => v.id === id);
                if (visit) {
                    const entryInput = document.querySelector(`#edit-entry-${id}`);
                    const exitInput = document.querySelector(`#edit-exit-${id}`);
                    const locationInput = document.querySelector(`#edit-location-${id}`);
                    
                    const entry = new Date(entryInput.value);
                    const exit = new Date(exitInput.value);
                    
                    if (entry > exit) {
                        showError('Entry date must be before exit date');
                        return;
                    }
                    
                    visit.entry = entryInput.value;
                    visit.exit = exitInput.value;
                    visit.location = locationInput.value;
                    visit.days = Math.ceil((exit - entry) / (1000 * 60 * 60 * 24)) + 1;
                    visit.isEditing = false;
                    delete visit._backup;
                    
                    saveVisits();
                    updateCalculations();
                    updateFutureTripDisplay();
                    renderVisits();
                }
            };

            window.generateShareUrl = function() {
                if (state.visits.length === 0) return;

                try {
                    const encodedData = safeBase64Encode(state.visits);
                    const baseUrl = window.location.origin + window.location.pathname;
                    const url = `${baseUrl}?data=${encodedData}`;
                    state.shareUrl = url;
                    
                    const container = document.getElementById('share-url-container');
                    const input = document.getElementById('share-url-input');
                    if (container && input) {
                        input.value = url;
                        container.classList.remove('hidden');
                    }
                } catch (error) {
                    console.error('Error generating share URL:', error);
                    showError('Failed to generate share link');
                }
            };

            window.copyToClipboard = async function() {
                if (!state.shareUrl) return;

                try {
                    await navigator.clipboard.writeText(state.shareUrl);
                    state.copied = true;
                    const copyBtn = document.getElementById('copy-btn');
                    if (copyBtn) {
                        copyBtn.innerHTML = '<i data-lucide="check" class="w-3.5 h-3.5"></i><span>Copied!</span>';
                        setTimeout(() => {
                            copyBtn.innerHTML = '<i data-lucide="copy" class="w-3.5 h-3.5"></i><span>Copy</span>';
                            state.copied = false;
                            if (window.lucide) lucide.createIcons();
                        }, 2000);
                    }
                    if (window.lucide) lucide.createIcons();
                } catch (error) {
                    console.error('Failed to copy to clipboard:', error);
                    showError('Failed to copy link');
                }
            };

            window.shareNatively = async function() {
                if (state.visits.length === 0) return;

                generateShareUrl();
                if (!state.shareUrl) return;

                if (navigator.share) {
                    try {
                        await navigator.share({
                            title: 'My Schengen Travel History',
                            text: 'Check out my Schengen 90/180 travel tracker data',
                            url: state.shareUrl
                        });
                    } catch (error) {
                        console.log('Native share cancelled or failed:', error);
                        await copyToClipboard();
                    }
                } else {
                    await copyToClipboard();
                }
            };

            window.saveToMyData = function() {
                state.isSharedData = false;
                saveVisits();
                updateSharedBanner();
            };

            // Helper functions
            function showError(message) {
                state.error = message;
                const banner = document.getElementById('error-banner');
                const text = document.getElementById('error-text');
                if (banner && text) {
                    text.textContent = message;
                    banner.classList.remove('hidden');
                    setTimeout(() => {
                        banner.classList.add('hidden');
                        state.error = '';
                    }, 5000);
                }
            }

            function safeBase64Encode(data) {
                try {
                    const jsonString = JSON.stringify(data);
                    const utf8Bytes = new TextEncoder().encode(jsonString);
                    const binaryString = Array.from(utf8Bytes, byte => String.fromCharCode(byte)).join('');
                    return btoa(binaryString);
                } catch (error) {
                    console.error('Base64 encoding error:', error);
                    throw new Error('Failed to encode data');
                }
            }

            function safeBase64Decode(encodedData) {
                try {
                    const binaryString = atob(encodedData);
                    const bytes = new Uint8Array(binaryString.length);
                    for (let i = 0; i < binaryString.length; i++) {
                        bytes[i] = binaryString.charCodeAt(i);
                    }
                    const jsonString = new TextDecoder().decode(bytes);
                    return JSON.parse(jsonString);
                } catch (error) {
                    console.error('Base64 decoding error:', error);
                    throw new Error('Failed to decode data');
                }
            }

            function loadVisits() {
                const urlParams = new URLSearchParams(window.location.search);
                const sharedData = urlParams.get('data');

                if (sharedData) {
                    try {
                        const decodedData = safeBase64Decode(sharedData);
                        state.visits = decodedData;
                        state.isSharedData = true;
                    } catch (error) {
                        console.error('Invalid shared data:', error);
                        showError('Invalid shared data in URL');
                        const savedVisits = localStorage.getItem('schengen-visits');
                        if (savedVisits) {
                            state.visits = JSON.parse(savedVisits);
                        }
                    }
                } else {
                    const savedVisits = localStorage.getItem('schengen-visits');
                    if (savedVisits) {
                        state.visits = JSON.parse(savedVisits);
                    }
                }
            }

            function saveVisits() {
                if (!state.isSharedData) {
                    localStorage.setItem('schengen-visits', JSON.stringify(state.visits));
                }
            }

            function formatDate(dateStr) {
                return new Date(dateStr).toLocaleDateString('en-US', {
                    month: 'short',
                    day: 'numeric',
                    year: 'numeric'
                });
            }

            function updateCalculations() {
                const today = new Date();
                const cutoffDate = new Date(today);
                cutoffDate.setDate(cutoffDate.getDate() - 180);

                // Filter visits within the last 180 days
                const relevantVisits = state.visits.filter(visit => {
                    const exitDate = new Date(visit.exit);
                    return exitDate >= cutoffDate;
                });

                // Calculate total days used in rolling 180-day period
                let totalDays = 0;
                relevantVisits.forEach(visit => {
                    const entryDate = new Date(visit.entry);
                    const exitDate = new Date(visit.exit);

                    const startDate = entryDate < cutoffDate ? cutoffDate : entryDate;
                    const endDate = exitDate > today ? today : exitDate;

                    if (startDate <= endDate) {
                        const days = Math.ceil((endDate - startDate) / (1000 * 60 * 60 * 24)) + 1;
                        totalDays += Math.max(0, days);
                    }
                });

                state.daysUsed = Math.min(totalDays, 90);
                state.daysRemaining = Math.max(0, 90 - state.daysUsed);

                // Update UI
                const daysUsedEl = document.getElementById('days-used');
                const daysRemainingEl = document.getElementById('days-remaining');
                const daysRemainingCard = document.getElementById('days-remaining-card');
                
                if (daysUsedEl) daysUsedEl.textContent = `${state.daysUsed}/90`;
                if (daysRemainingEl) daysRemainingEl.textContent = state.daysRemaining;
                
                if (daysRemainingCard) {
                    daysRemainingCard.className = daysRemainingCard.className.replace(
                        /border-(red|yellow|green)-\\d+/g, ''
                    ).replace(/dark:border-(red|yellow|green)-\\d+/g, '');
                    
                    if (state.daysRemaining <= 10) {
                        daysRemainingCard.classList.add('border-red-200', 'dark:border-red-800');
                        daysRemainingEl.className = daysRemainingEl.className.replace(
                            /(text-(red|yellow|green)-\\d+|dark:text-(red|yellow|green)-\\d+)/g, ''
                        ) + ' text-red-600 dark:text-red-400';
                    } else if (state.daysRemaining <= 30) {
                        daysRemainingCard.classList.add('border-yellow-200', 'dark:border-yellow-800');
                        daysRemainingEl.className = daysRemainingEl.className.replace(
                            /(text-(red|yellow|green)-\\d+|dark:text-(red|yellow|green)-\\d+)/g, ''
                        ) + ' text-yellow-600 dark:text-yellow-400';
                    } else {
                        daysRemainingCard.classList.add('border-green-200', 'dark:border-green-800');
                        daysRemainingEl.className = daysRemainingEl.className.replace(
                            /(text-(red|yellow|green)-\\d+|dark:text-(red|yellow|green)-\\d+)/g, ''
                        ) + ' text-green-600 dark:text-green-400';
                    }
                }

                // Calculate next reset date
                if (relevantVisits.length > 0) {
                    const earliestRelevantVisit = relevantVisits.sort((a, b) => new Date(a.entry) - new Date(b.entry))[0];
                    const earliestExit = new Date(earliestRelevantVisit.exit);
                    const resetDate = new Date(earliestExit);
                    resetDate.setDate(resetDate.getDate() + 181);

                    if (resetDate > today) {
                        state.nextResetDate = resetDate.toLocaleDateString('en-US', {
                            weekday: 'long',
                            year: 'numeric',
                            month: 'long',
                            day: 'numeric'
                        });
                    } else {
                        state.nextResetDate = null;
                    }
                } else {
                    state.nextResetDate = null;
                }

                // Update next reset UI
                const nextResetEl = document.getElementById('next-reset');
                const resetDescriptionEl = document.getElementById('reset-description');
                const resetDaysEl = document.getElementById('reset-days');
                
                if (nextResetEl) {
                    nextResetEl.textContent = state.nextResetDate || 'No visits yet';
                }
                
                if (resetDescriptionEl && resetDaysEl) {
                    if (state.nextResetDate && state.visits.length > 0) {
                        resetDescriptionEl.classList.remove('hidden');
                        resetDaysEl.classList.remove('hidden');
                        resetDaysEl.textContent = `${state.visits[0]?.days || 0} ${state.visits[0]?.days === 1 ? 'day' : 'days'} will be restored on this date`;
                    } else {
                        resetDescriptionEl.classList.add('hidden');
                        resetDaysEl.classList.add('hidden');
                    }
                }
            }

            function calculateFutureTripImpact() {
                const today = new Date();
                
                // Get all visits (past and future)
                const allVisits = [...state.visits];
                
                // Separate current/past visits from future visits
                const futureVisits = allVisits.filter(visit => {
                    const entryDate = new Date(visit.entry);
                    return entryDate > today;
                });
                
                if (futureVisits.length === 0) {
                    return { futureDaysRemaining: null, latestFutureVisitId: null };
                }
                
                // Find the latest future trip exit date and its visit
                let latestFutureExit = new Date(0);
                let latestFutureVisit = null;
                
                futureVisits.forEach(visit => {
                    const exitDate = new Date(visit.exit);
                    if (exitDate > latestFutureExit) {
                        latestFutureExit = exitDate;
                        latestFutureVisit = visit;
                    }
                });
                
                // Calculate the 180-day window from the latest future trip
                const futureCutoffDate = new Date(latestFutureExit);
                futureCutoffDate.setDate(futureCutoffDate.getDate() - 180);
                
                // Calculate total days that will be used in this future window
                let totalFutureDays = 0;
                allVisits.forEach(visit => {
                    const entryDate = new Date(visit.entry);
                    const exitDate = new Date(visit.exit);
                    
                    // Check if this visit overlaps with the future 180-day window
                    if (exitDate >= futureCutoffDate && entryDate <= latestFutureExit) {
                        const startDate = entryDate < futureCutoffDate ? futureCutoffDate : entryDate;
                        const endDate = exitDate > latestFutureExit ? latestFutureExit : exitDate;
                        
                        if (startDate <= endDate) {
                            const days = Math.ceil((endDate - startDate) / (1000 * 60 * 60 * 24)) + 1;
                            totalFutureDays += Math.max(0, days);
                        }
                    }
                });
                
                const futureDaysRemaining = Math.max(0, 90 - Math.min(totalFutureDays, 90));
                return {
                    futureDaysRemaining: futureDaysRemaining,
                    latestFutureVisitId: latestFutureVisit ? latestFutureVisit.id : null
                };
            }

            function updateFutureTripDisplay() {
                const futureImpact = calculateFutureTripImpact();
                const daysAfterPlannedEl = document.getElementById('days-after-planned');
                const daysAfterPlannedContainer = document.getElementById('days-after-planned-container');
                const daysRemainingEl = document.getElementById('days-remaining');
                
                // Update state with latest future visit ID
                state.latestFutureVisitId = futureImpact.latestFutureVisitId;
                
                if (daysAfterPlannedEl && daysAfterPlannedContainer && daysRemainingEl) {
                    if (futureImpact.futureDaysRemaining !== null && futureImpact.futureDaysRemaining !== state.daysRemaining) {
                        // Show current remaining without change, and future remaining in faded container
                        daysRemainingEl.textContent = state.daysRemaining;
                        daysAfterPlannedEl.textContent = futureImpact.futureDaysRemaining;
                        daysAfterPlannedContainer.classList.remove('hidden');
                    } else {
                        // Show current remaining and hide future container
                        daysRemainingEl.textContent = state.daysRemaining;
                        daysAfterPlannedContainer.classList.add('hidden');
                    }
                }
            }

            function updateAddButton() {
                const entryDate = document.getElementById('entry-date').value;
                const exitDate = document.getElementById('exit-date').value;
                const btn = document.getElementById('add-visit-btn');
                
                if (btn) {
                    if (entryDate && exitDate) {
                        btn.disabled = false;
                        btn.className = btn.className.replace(/bg-gray-\\d+|dark:bg-zinc-\\d+/g, '') + ' bg-teal-600 hover:bg-teal-700 dark:bg-teal-500 dark:hover:bg-teal-600';
                    } else {
                        btn.disabled = true;
                        btn.className = btn.className.replace(/bg-teal-\\d+|hover:bg-teal-\\d+|dark:bg-teal-\\d+|dark:hover:bg-teal-\\d+/g, '') + ' bg-gray-400 dark:bg-zinc-600';
                    }
                }
            }

            function updateSharedBanner() {
                const banner = document.getElementById('shared-banner');
                if (banner) {
                    if (state.isSharedData) {
                        banner.classList.remove('hidden');
                    } else {
                        banner.classList.add('hidden');
                    }
                }
            }

            function renderVisits() {
                const header = document.getElementById('visits-header');
                const emptyState = document.getElementById('empty-state');
                const visitsList = document.getElementById('visits-list');
                
                if (header) header.textContent = `Previous Visits (${state.visits.length})`;
                
                if (state.visits.length === 0) {
                    if (emptyState) emptyState.classList.remove('hidden');
                    if (visitsList) visitsList.classList.add('hidden');
                } else {
                    if (emptyState) emptyState.classList.add('hidden');
                    if (visitsList) {
                        visitsList.classList.remove('hidden');
                        visitsList.innerHTML = state.visits.map(visit => `
                            <div class="bg-white dark:bg-zinc-800 border border-zinc-200 dark:border-zinc-700 rounded-lg p-4 hover:shadow-sm transition-shadow">
                                <div class="flex flex-col sm:flex-row sm:items-center gap-3">
                                    ${visit.isEditing ? `
                                        <div class="flex-1 min-w-0">
                                            <div class="grid grid-cols-1 sm:grid-cols-4 gap-2 text-sm mb-3 sm:mb-0">
                                                <input type="date" id="edit-entry-${visit.id}" value="${visit.entry}" class="px-2 py-1.5 sm:p-2 border border-zinc-300 dark:border-zinc-600 bg-white dark:bg-gray-700 text-zinc-900 dark:text-zinc-100 rounded text-sm">
                                                <input type="date" id="edit-exit-${visit.id}" value="${visit.exit}" class="px-2 py-1.5 sm:p-2 border border-zinc-300 dark:border-zinc-600 bg-white dark:bg-gray-700 text-zinc-900 dark:text-zinc-100 rounded text-sm">
                                                <input type="text" id="edit-location-${visit.id}" value="${visit.location}" placeholder="Location" class="px-2 py-1.5 sm:p-2 border border-zinc-300 dark:border-zinc-600 bg-white dark:bg-gray-700 text-zinc-900 dark:text-zinc-100 rounded text-sm sm:col-span-1">
                                                <div class="flex items-center">
                                                    <span class="text-teal-600 dark:text-teal-400 bg-teal-50 dark:bg-teal-900/50 px-2 py-1 rounded text-xs">${visit.days} ${visit.days === 1 ? 'day' : 'days'}</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="flex items-center gap-2 justify-end sm:justify-start flex-shrink-0">
                                            <button onclick="saveEdit(${visit.id})" class="text-green-600 hover:text-green-800 dark:text-green-400 dark:hover:text-green-300 p-2 rounded-lg hover:bg-green-50 dark:hover:bg-green-900/50 transition-colors" title="Save">
                                                <i data-lucide="check" class="w-4 h-4"></i>
                                            </button>
                                            <button onclick="cancelEdit(${visit.id})" class="text-zinc-500 hover:text-zinc-700 dark:text-zinc-400 dark:hover:text-zinc-200 p-2 rounded-lg hover:bg-zinc-100 dark:hover:bg-zinc-700 transition-colors" title="Cancel">
                                                <i data-lucide="x" class="w-4 h-4"></i>
                                            </button>
                                        </div>
                                    ` : `
                                        <div class="flex-1 min-w-0">
                                            <div class="flex flex-col sm:flex-row sm:items-center gap-2 sm:gap-4 text-sm">
                                                <span class="font-medium text-zinc-900 dark:text-zinc-100">${formatDate(visit.entry)} - ${formatDate(visit.exit)}</span>
                                                <span class="text-zinc-600 dark:text-zinc-400">${visit.location || 'Schengen Area'}</span>
                                                <span class="text-teal-600 dark:text-teal-400 bg-teal-50 dark:bg-teal-900/50 px-2 py-1 rounded text-xs self-start">${visit.days} ${visit.days === 1 ? 'day' : 'days'}</span>
                                            </div>
                                        </div>
                                        <div class="flex items-center gap-2 justify-end sm:justify-start flex-shrink-0">
                                            <button onclick="startEdit(${visit.id})" class="text-zinc-500 hover:text-zinc-700 dark:text-zinc-400 dark:hover:text-zinc-200 p-2 rounded-lg hover:bg-zinc-100 dark:hover:bg-zinc-700 transition-colors" title="Edit visit">
                                                <i data-lucide="edit-2" class="w-4 h-4"></i>
                                            </button>
                                            <button onclick="removeVisit(${visit.id})" class="text-red-500 hover:text-red-700 dark:text-red-400 dark:hover:text-red-300 p-2 rounded-lg hover:bg-red-50 dark:hover:bg-red-900/50 transition-colors" title="Delete visit">
                                                <i data-lucide="trash-2" class="w-4 h-4"></i>
                                            </button>
                                        </div>
                                    `}
                                </div>
                            </div>
                        `).join('');
                    }
                }

                // Reinitialize icons after DOM update
                setTimeout(() => {
                    if (window.lucide) lucide.createIcons();
                }, 50);
            }

            // Initialize app
            function init() {
                loadVisits();
                updateCalculations();
                updateFutureTripDisplay();
                renderVisits();
                updateSharedBanner();

                // Add event listeners for form inputs
                const entryInput = document.getElementById('entry-date');
                const exitInput = document.getElementById('exit-date');
                
                if (entryInput) entryInput.addEventListener('input', updateAddButton);
                if (exitInput) exitInput.addEventListener('input', updateAddButton);
                
                updateAddButton();

                setTimeout(() => {
                    if (window.lucide) lucide.createIcons();
                }, 100);
            }

            // Initialize when DOM is ready
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', init);
            } else {
                init();
            }
        })();
        """
      })
    }
  }
}
